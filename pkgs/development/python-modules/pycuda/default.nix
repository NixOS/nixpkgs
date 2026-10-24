{
  _cuda,
  boost,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,
  lib,
  mako,
  numpy,
  platformdirs,
  python,
  pytools,
  setuptools,
  writableTmpDirAsHomeHook,
  writeShellApplication,
  stdenvNoCC,
}:
let
  inherit (_cuda.lib) dropDots;
  inherit (cudaPackages)
    backendStdenv
    cuda_cudart
    cccl
    cuda_crt
    cuda_nvcc
    cuda_profiler_api
    libcurand
    ;
  inherit (lib)
    getBin
    getFirstOutput
    getInclude
    getLib
    licenses
    maintainers
    optionals
    teams
    ;

  # Headers made available to kernels compiled at runtime by pycuda.compiler.
  runtimeIncludeDirs = map (pkg: "${getInclude pkg}/include") (
    [
      cuda_nvcc
      cuda_cudart
      cccl
      cuda_profiler_api
      libcurand
    ]
    # On CUDA 13 and later, crt/host_config.h (included by cuda_runtime.h) is shipped in cuda_crt.
    ++ optionals cuda_crt.meta.available [ cuda_crt ]
  );
in
buildPythonPackage.override { stdenv = backendStdenv; } (finalAttrs: {
  __structuredAttrs = true;

  pname = "pycuda";
  version = "2026.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pycuda";
    tag = "v${finalAttrs.version}";
    # Use the vendored compyte source rather than tracking it as a separate dependency.
    # As an added bonus, this should unbreak the update script added by buildPythonPackage.
    fetchSubmodules = true;
    hash = "sha256-0+T8cS3pUh2wtRpAd7osboEJvK+Nes9+Sok52BZTX68=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cuda_nvcc
  ];

  prePatch = ''
    nixLog "removing vendored boost source"
    rm -rf "$PWD/bpl-subset"

    nixLog "patching $PWD/pycuda/compiler.py::compile to fix CUDA include paths"
    substituteInPlace "$PWD/pycuda/compiler.py" \
      --replace-fail \
        'include_dirs = [*include_dirs, _find_pycuda_include_path()]' \
        'include_dirs = [*include_dirs, *${builtins.toJSON runtimeIncludeDirs}, _find_pycuda_include_path()]'

    nixLog "patching $PWD/pycuda/compiler.py::compile to fix NVCC path"
    substituteInPlace "$PWD/pycuda/compiler.py" \
      --replace-fail \
        'nvcc="nvcc"' \
        'nvcc="${getBin cuda_nvcc}/bin/nvcc"'

    nixLog "patching $PWD/pycuda/compiler.py::DynamicModule.__init__ to fix CUDA runtime library path"
    substituteInPlace "$PWD/pycuda/compiler.py" \
      --replace-fail \
        'cuda_libdir=None,' \
        'cuda_libdir="${getLib cuda_cudart}/lib",'
  '';

  dependencies = [
    mako
    numpy
    platformdirs
    pytools
  ];

  buildInputs = [
    boost
    cccl
    cuda_cudart
    cuda_nvcc
    cuda_profiler_api
    libcurand
  ];

  configureScript = "./configure.py";

  # configure.py doesn't support the installation directory arguments _multioutConfig sets.
  # The other argument provided by configurePhase, like --prefix, --enable-shared, and --disable-static are ignored.
  setOutputFlags = false;

  configureFlags = [
    # The expected boost python library name is something like boost_python-py313, but our library name doesn't have a
    # hyphen. The pythonVersion is already a major-minor version, so we just need to remove the dot.
    "--no-use-shipped-boost"
    "--boost-python-libname=boost_python${dropDots python.pythonVersion}"
    # Provide paths to our CUDA libraries.
    "--cudadrv-lib-dir=${getFirstOutput [ "stubs" "lib" ] cuda_cudart}/lib/stubs"
  ];

  # Requires access to libcuda.so.1 which is provided by the driver
  doCheck = false;

  # From setup.py
  pythonImportsCheck = [
    "pycuda"
    # "pycuda.gl" # Requires the CUDA driver
    "pycuda.sparse"
    "pycuda.compyte"
  ];

  # TODO: Split into testers and tests.
  # NOTE: Tests take 23m to run on a 4090 and require 18GB of VRAM.
  passthru = {
    testers.tester = writeShellApplication {
      derivationArgs = {
        __structuredAttrs = true;
        strictDeps = true;
      };
      name = "pycuda-tester";
      runtimeInputs = [
        (python.withPackages (ps: [
          finalAttrs.finalPackage
          ps.pytest
        ]))
      ];
      text = ''
        echo "Copying pycuda test sources to $PWD/pycuda_test_sources"
        mkdir -p "$PWD/pycuda_test_sources"
        cp -r "${finalAttrs.src}"/test "$PWD/pycuda_test_sources"
        chmod -R u+w "$PWD/pycuda_test_sources"

        pushd "$PWD/pycuda_test_sources"
        pytest "$@"
        popd
      '';
    };
    tests =
      let
        makeTest =
          name: testArgs:
          stdenvNoCC.mkDerivation {
            __structuredAttrs = true;
            strictDeps = true;

            inherit name testArgs;

            dontUnpack = true;

            nativeBuildInputs = [
              finalAttrs.finalPackage.passthru.testers.tester
              writableTmpDirAsHomeHook
            ];

            dontConfigure = true;

            buildPhase = ''
              nixLog "using testArgs: ''${testArgs[*]@Q}"
              pycuda-tester "''${testArgs[@]}" || {
                nixErrorLog "pycuda-tester finished with non-zero exit code: $?"
                exit 1
              }
            '';

            postInstall = ''
              touch $out
            '';

            requiredSystemFeatures = [ "cuda" ];
          };
      in
      {
        # Fast: ~10s on a 4090
        driver = makeTest "pycuda-driver-tests" [ "test/test_driver.py" ];
        # Fast: ~16s on a 4090
        cumath = makeTest "pycuda-cumath-tests" [ "test/test_cumath.py" ];
        # Fast: ~3m on a 4090
        gpuarray-fast = makeTest "pycuda-gpuarray-fast-tests" [
          "test/test_gpuarray.py"
          "-k"
          "not test_curand_wrappers"
        ];
        # EXTREMELY SLOW: ~20m on a 4090
        gpuarray-slow = makeTest "pycuda-gpuarray-slow-tests" [
          "test/test_gpuarray.py"
          "-k"
          "test_curand_wrappers"
        ];
      };
  };

  meta = {
    description = "CUDA integration for Python";
    homepage = "https://github.com/inducer/pycuda/";
    license = licenses.mit;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [
      GaetanLepage
      connorbaker
    ];
    teams = [ teams.cuda ];
  };
})
