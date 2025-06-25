{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  setuptools,

  # nativeBuildInputs
  autoAddDriverRunpath,
  cudaPackages,

  # dependencies
  numpy,
  scipy,
}:

buildPythonPackage {
  pname = "gpu-rir";
  version = "0-unstable-2025-01-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidDiazGuerra";
    repo = "gpuRIR";
    rev = "fd8af43a4a113d3c2c05f0085a0119ecb1f1a484";
    hash = "sha256-nYi91iaNb9gswYzXW7aNpD3yYIgMvTen9r02G4d6joo=";
  };

  # Inject cmakeFlags in the cmake call
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "cmake_args = [" \
        "cmake_args = os.environ.get('cmakeFlags', \"\").split() + ["
  '';

  build-system = [
    cmake
    setuptools
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  # TODO: Investigate why (deprecated) FindCUDA fails to set these variables
  cmakeFlags = [
    (lib.cmakeFeature "CUDA_CUFFT_LIBARIES" "${lib.getLib cudaPackages.libcufft}/lib/libcufft.so")
    (lib.cmakeFeature "CUDA_curand_LIBRARY" "${lib.getLib cudaPackages.libcurand}/lib/libcurand.so")
  ];

  buildInputs = with cudaPackages; [
    cuda_cccl # <nv/target>
    cuda_cudart # cuda_runtime.h
    libcufft
    libcurand
  ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "gpuRIR" ];
  # Fails at import because there is no GPU access in the sandbox:
  # Check whether the following modules can be imported: gpuRIR
  # GPUassert: CUDA driver version is insufficient for CUDA runtime version /build/source/src/gpuRIR_cuda.cu 1037
  dontUsePythonImportsCheck = true;

  # No tests
  doCheck = false;

  meta = {
    description = "Python library for Room Impulse Response (RIR) simulation with GPU acceleration";
    homepage = "https://github.com/DavidDiazGuerra/gpuRIR";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
