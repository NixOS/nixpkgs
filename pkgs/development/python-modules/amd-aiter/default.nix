{
  lib,
  amd-aiter,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  ninja,
  numpy,
  packaging,
  pandas,
  psutil,
  pybind11,
  python,
  rocmPackages,
  runCommand,
  setuptools,
  setuptools-scm,
  torch,
  writableTmpDirAsHomeHook,
}:
let
  # Provide a default set of include paths needed by aiter at runtime for JIT modules
  defaultRocmIncl = lib.makeIncludePath (
    (with rocmPackages; [
      clr
      hipblas
      hipblas-common
      hipblaslt
      hipcub
      hipfft
      hipsolver
      hipsparse
      rocblas
      rocprim
      rocsolver
      rocsparse
      rocthrust
    ])
    ++ [
      pybind11
    ]
  );
in
buildPythonPackage (finalAttrs: {
  pname = "amd-aiter";
  version = "0.1.11.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "aiter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9CCSmEw0kIoxERhtkKhBkaAGx42kCssH7IPjTgbg9LA=";
  };

  postPatch = ''
    rmdir 3rdparty/composable_kernel
    ln -sf ${rocmPackages.composable_kernel.src} 3rdparty/composable_kernel

    substituteInPlace pyproject.toml \
      --replace-fail '"flydsl==0.0.1.dev95158637"' ""

    # TODO: upstream fix. get_git_commit_id_short() assumes a git clone;
    # fails in hermetic builds, should fall back gracefully.
    substituteInPlace csrc/cpp_itfs/utils.py \
      --replace-fail \
        'commit_id = get_git_commit_id_short()' \
        'commit_id = "${finalAttrs.version}"'

    # NIX_AITER_ROCM_INCL is a colon-separated list of include dirs
    # defaults to packages known to be needed by aiter
    substituteInPlace aiter/jit/utils/cpp_extension.py \
      --replace-fail \
        'paths.append(_join_rocm_home("include"))' \
        'paths.append(_join_rocm_home("include")); paths.extend(os.environ.get("NIX_AITER_ROCM_INCL", "${defaultRocmIncl}").split(":"))'

    # setuptools runs setup.py twice (metadata + wheel). prepare_packaging()
    # copies 3rdparty/ (with nix store read-only files) into aiter_meta/, then
    # the second run can't rmtree or overwrite them.
    substituteInPlace setup.py \
      --replace-fail \
        $'prepare_packaging()\n\n\nclass' \
        $'if not os.path.exists("aiter_meta"): prepare_packaging()\n\n\nclass' \
      --replace-fail \
        'if os.path.exists("aiter_meta") and os.path.isdir("aiter_meta"):' \
        'if False:'
  '';

  env = {
    BUILD_TARGET = "rocm";
    PREBUILD_KERNELS = "0";
    ROCM_PATH = "${rocmPackages.clr}";
    SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;
  };

  build-system = [
    ninja
    packaging
    pandas
    psutil
    pybind11
    setuptools
    setuptools-scm
  ];

  buildInputs = [ rocmPackages.clr ];

  nativeBuildInputs = [
    rocmPackages.hipcc
    writableTmpDirAsHomeHook
  ];

  dependencies = [
    einops
    ninja
    numpy
    packaging
    pandas
    psutil
    pybind11
    torch
  ];

  # Most tests and imports require a GPU and writable $HOME for JIT cache
  doCheck = false;

  # Test JIT module builds for CDNA3 iff rocm enabled for torch
  passthru.tests = lib.optionalAttrs torch.rocmSupport (
    let
      mkJitTest =
        name: moduleName:
        runCommand "amd-aiter-jit-${name}"
          {
            nativeBuildInputs = [
              (python.withPackages (_: [ amd-aiter ]))
              rocmPackages.clr
              writableTmpDirAsHomeHook
            ];
            env = {
              CXX = "amdclang++";
              GPU_ARCHS = "gfx942";
              PYTORCH_ROCM_ARCH = "gfx942";
            };
          }
          ''
            export AITER_JIT_DIR=$(mktemp -d)
            python3 -c "
            from aiter.jit.core import get_args_of_build, build_module
            args = get_args_of_build('${moduleName}')
            build_module(
                '${moduleName}',
                args['srcs'], args['flags_extra_cc'], args['flags_extra_hip'],
                args['blob_gen_cmd'], args['extra_include'], args['extra_ldflags'],
                args['verbose'], args['is_python_module'], args['is_standalone'],
                args['torch_exclude'],
            )
            print('JIT compile of ${moduleName} finished')
            "
            touch $out
          '';
    in
    {
      jit-module-opus-sort = mkJitTest "opus-sort" "module_moe_sorting_opus";
      jit-module-mhc = mkJitTest "mhc" "module_mhc";
    }
  );

  meta = {
    description = "AI Tensor Engine for ROCm";
    homepage = "https://github.com/ROCm/aiter";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [ lach ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
