{
  lib,
  config,
  buildPythonPackage,
  cudaPackages,

  # build-system
  cython,
  setuptools,

  # dependencies
  numpy,
  cuda-bindings,
  cuda-core,
  cuda-pathfinder,

  cudaSupport ? config.cudaSupport,
}:
let
  inherit (cudaPackages) cudaMajorVersion libnvshmem;
in
buildPythonPackage.override { stdenv = cudaPackages.backendStdenv; } (finalAttrs: {
  pname = "nvshmem4py-cu${cudaMajorVersion}";
  # nvshmem4py lives inside the nvshmem source tree and is versioned independently
  # (setuptools-scm output committed in nvshmem/version.py).
  version = "0.1.2";
  pyproject = true;
  __structuredAttrs = true;

  inherit (libnvshmem) src;
  sourceRoot = "${finalAttrs.src.name}/nvshmem4py";

  postPatch =
    # Upstream ships no pyproject.toml (it is generated at "wheel farm" time by
    # scripts/generate_pyproject_toml.py, which also injects PyPI-only runtime
    # deps like nvidia-nvshmem-cu12). We author a minimal one ourselves and let
    # Nix provide the dependencies.
    ''
      cat > pyproject.toml <<EOF
      [build-system]
      requires = ["setuptools", "Cython"]
      build-backend = "setuptools.build_meta"

      [project]
      name = "${finalAttrs.pname}"
      version = "${finalAttrs.version}"
      description = "Python bindings for NVSHMEM"

      [tool.setuptools.packages.find]
      include = ["nvshmem*"]

      [tool.setuptools.package-data]
      "nvshmem.bindings" = ["*.pxd", "*.so"]
      "nvshmem.bindings._internal" = ["*.pxd", "*.so"]
      "nvshmem.bindings.device.numba" = ["entry_point.h"]
      "nvshmem.bindings.device.cute" = ["entry_point.h"]
      EOF
    ''
    # setup.py reads requirements.txt into install_requires at build time; that
    # file only exists after the CMake harness copies a requirements_cudaNN.txt
    # over it. We handle runtime deps in Nix, so drop the read entirely.
    + ''
      substituteInPlace setup.py \
        --replace-fail \
          'install_requires=open(f"{os.path.dirname(__file__)}/requirements.txt").read().splitlines())' \
          ')'
    ''
    # _numbast.py (the numba device bindings) is a 5.7MB git-LFS blob that fetchFromGitHub does not
    # resolve, so it arrives as a pointer stub that breaks byte-compilation.
    # It also requires numba-cuda (unpackaged) to be useful.
    # Upstream's numba __init__ gracefully disables itself when the file is absent, so just drop the stub.
    + ''
      rm nvshmem/bindings/device/numba/_numbast.py
    ''
    # The bindings dlopen the host library by bare soname at runtime.
    # Pin it to the store path so it is found without LD_LIBRARY_PATH.
    + ''
      substituteInPlace \
        nvshmem/bindings/_internal/nvshmem.pyx \
        nvshmem/bindings/_internal/nvshmem_linux.pyx \
        --replace-warn \
          '"libnvshmem_host.so.3"' \
          '"${lib.getLib libnvshmem}/lib/libnvshmem_host.so.3"'
    '';

  # setup.py hardcodes PACKAGE_NAME from the environment.
  env.PACKAGE_NAME = finalAttrs.pname;

  build-system = [
    cython
    setuptools
  ];

  # CUDA runtime headers (cuda_runtime_api.h, cuda_fp16.h, cuda_bf16.h) needed to
  # compile the Cython extensions. No link-time nvshmem: it is dlopen'd at runtime.
  # cuda_nvcc provides the crt/ headers that cuda_runtime_api.h pulls in.
  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
  ];

  dependencies = [
    numpy
    cuda-bindings
    cuda-core
    cuda-pathfinder
  ];

  pythonImportsCheck = [
    "nvshmem"
    "nvshmem.core"
  ];

  meta = {
    description = "Pythonic interface to NVSHMEM";
    homepage = "https://github.com/NVIDIA/nvshmem";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    broken = !cudaSupport;
  };
})
