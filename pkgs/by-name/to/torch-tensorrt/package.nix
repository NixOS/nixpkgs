{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,

  # nativeBuildInputs
  cmake,
  ninja,

  python3Packages,
}:
let
  inherit (lib) getInclude;
  inherit (python3Packages) python torch;
  # torch's CUDA package set, so the libraries build against the CUDA torch uses.
  inherit (torch) cudaPackages;
in
# The C++ libraries (libtorchtrt for the TorchScript frontend, libtorchtrt_runtime for the C++ runtime, and
# libtorchtrt_plugins), torchtrtc, and the Python wheel, which python3Packages.torch-tensorrt installs. The wheel's
# extension module (torch_tensorrt._C) links against libtorchtrt.
cudaPackages.backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "torch-tensorrt";
  # Releases track PyTorch minor versions (each requires torch>=X.Y,<X.(Y+1)); keep this in step with torch.
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "TensorRT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zBnEy/BMwweEt9V41i2WnT3oJxqrrKLHZLXpclAvcwc=";
  };

  patches = [
    # Don't query the CUDA device on import (`import torch_tensorrt` fails without a GPU, as in pythonImportsCheck).
    # https://github.com/pytorch/TensorRT/pull/4504, merged after 2.14.0; remove when updating to 2.15.
    (fetchpatch2 {
      name = "fix-cpu-only-import.patch";
      url = "https://github.com/pytorch/TensorRT/commit/1caa73d0748391700d53ef4c3c66d1a78650766f.patch?full_index=1";
      hash = "sha256-QNNjuaF2OHk1V1wo0w17zWlFpyJDfAsS2sC0Qp8v2EI=";
    })

    # Upstream builds the libraries with Bazel, which uses the installed torch but downloads TensorRT and its Bazel
    # module dependencies. Its CMake build, used here instead, builds with C++17, which PyTorch's headers no longer
    # compile with, and lacks sources and a define the Bazel build has: the runtime settings and runtime config (without
    # which linking torchtrtc fails with undefined references), TRT_HAS_IRUNTIME_CONFIG, three TorchScript converters,
    # and the plugins in libtorchtrt. Upstream's main branch (154a1bd) still lacks them. Not submitted upstream:
    # upstream's CI builds libtorchtrt and torchtrtc only with Bazel and never configures this CMake build (its CMake
    # jobs build only the ExecuTorch backend and examples), so this patch is checked here, against each release. Made
    # with `git format-patch` from a commit on top of v2.14.0.
    ./cmake-build-bazel-sources.patch

    # torch_tensorrt._C allocates TRTEngine objects that libtorchtrt's constructor initializes. TRTEngine's layout
    # depends on two macros that libtorchtrt is compiled with and setup.py doesn't give the extension
    # (TRT_HAS_IRUNTIME_CONFIG, and USE_C10D_NCCL when torch has NCCL), so the extension allocates less memory than the
    # constructor writes: an engine made by torch._C._jit_to_backend corrupts the heap, and glibc aborts. Upstream's
    # wheels have the same mismatch. Declare the members those macros add whatever the macros; this also re-enables
    # upstream's test of that path, tests/py/ts/integrations/test_to_backend_api.py. A backport to v2.14.0 of
    # https://github.com/pytorch/TensorRT/pull/4940, which is not merged, made with `git format-patch`; remove when
    # updating to a release that contains it.
    ./trtengine-layout-independent-of-macros.patch
  ];

  postPatch =
    # cffi, ninja and pybind11 (pinned to 2.6.2) are build requirements of the wheel that nothing uses: the extension
    # is built with torch's pybind11, and with setuptools instead of ninja.
    ''
      substituteInPlace pyproject.toml \
        --replace-fail '"cffi>=1.15.1",' "" \
        --replace-fail '"ninja>=1.11.0",' "" \
        --replace-fail '"pybind11==2.6.2",' ""
    ''
    # setup.py builds the libraries with Bazel, unpacks Bazel's archive of them into py/torch_tensorrt, and asks Bazel
    # where TensorRT's headers are. Use the libraries built with CMake (see postInstall) and cudaPackages.tensorrt.
    + ''
      substituteInPlace setup.py \
        --replace-fail 'sys.exit("Could not find bazel in PATH")' 'pass' \
        --replace-fail 'build_libtorchtrt_cxx11_abi(develop=False, rt_only=NO_TS)' 'pass' \
        --replace-fail 'copy_libtorchtrt(rt_only=NO_TS)' 'pass' \
        --replace-fail \
          'f"{tensorrt_linux_external_dir()}/include"' \
          '"${getInclude cudaPackages.tensorrt}/include"'
    ''
    # Upstream builds 2.14.0 with TensorRT 11.1; this uses cudaPackages' default TensorRT (11.4 when written), with
    # which python3Packages.torch-tensorrt's GPU checks pass. Record it in torch_tensorrt._version instead of 11.1.0.
    + ''
      substituteInPlace dev_dep_versions.yml \
        --replace-fail \
          '__tensorrt_version__: "11.1.0"' \
          '__tensorrt_version__: "${cudaPackages.tensorrt.version}"'
    '';

  outputs = [
    "out"
    "dist" # Python wheel output
  ];

  nativeBuildInputs = [
    cmake
    cudaPackages.cuda_nvcc
    ninja
    python
  ]
  ++ (with python3Packages; [
    build
    packaging
    pyyaml
    setuptools
    torch # setup.py imports torch, and builds the extension with torch.utils.cpp_extension
    wheel
  ]);

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.tensorrt
    torch
    torch.cxxdev
  ]
  # torch's CMake configuration defines USE_C10D_NCCL when torch is built with NCCL, which makes the runtime include
  # torch's ProcessGroupNCCL.hpp, and so nccl.h, to support TensorRT's native NCCL collectives.
  ++ lib.optionals cudaPackages.nccl.meta.available [
    (lib.getDev cudaPackages.nccl)
  ];

  env = {
    # The wheel's version is `version`, rather than `<version.txt>.dev0+<git hash>`.
    RELEASE = "1";
    BUILD_VERSION = finalAttrs.version;

    # Recorded in torch_tensorrt.__cuda_version__ instead of the CUDA version in dev_dep_versions.yml.
    CU_VERSION = "cu${lib.replaceStrings [ "." ] [ "" ] cudaPackages.cudaMajorMinorVersion}";

    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" torch.cudaCapabilities;
  };

  # Build the wheel from the source tree, with the libraries setup.py would have unpacked from Bazel's archive in
  # py/torch_tensorrt: lib (which the extension links against), bin and include.
  postInstall = ''
    pushd ..
    mkdir -p py/torch_tensorrt/{bin,lib}
    cp -v "$out"/lib/libtorchtrt{,_plugins,_runtime}.so py/torch_tensorrt/lib/
    cp -v "$out"/bin/torchtrtc py/torch_tensorrt/bin/
    cp -rv "$out"/include py/torch_tensorrt/include
    export MAX_JOBS="$NIX_BUILD_CORES"
    nixLog "building Python wheel"
    pyproject-build \
      --no-isolation \
      --outdir "$dist/" \
      --wheel
    popd >/dev/null
  '';

  passthru = {
    # Only follow releases for torch's minor version. Use GitHub's releases rather than its feed, which holds the 10
    # newest tags: release candidates for the next minor version can fill it (2.13.0 had 13).
    updateScript = nix-update-script {
      extraArgs = [
        "--use-github-releases"
        "--version-regex"
        "^v(${lib.escapeRegex (lib.versions.majorMinor torch.version)}\\..*)$"
      ];
    };
  };

  meta = {
    description = "PyTorch compiler for NVIDIA GPUs using TensorRT";
    homepage = "https://docs.pytorch.org/TensorRT/";
    downloadPage = "https://github.com/pytorch/TensorRT";
    changelog = "https://github.com/pytorch/TensorRT/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "torchtrtc";
    problems =
      lib.optionalAttrs
        (
          !torch.cudaSupport
          || lib.versions.majorMinor torch.version != lib.versions.majorMinor finalAttrs.version
        )
        {
          broken.message =
            "torch-tensorrt ${finalAttrs.version} needs a CUDA build of torch ${lib.versions.majorMinor finalAttrs.version}.x;"
            + " got torch ${torch.version}${lib.optionalString (!torch.cudaSupport) " without CUDA"}.";
        };
    maintainers = with lib.maintainers; [ connorbaker ];
    teams = [ lib.teams.cuda ];
    platforms = lib.platforms.linux;
  };
})
