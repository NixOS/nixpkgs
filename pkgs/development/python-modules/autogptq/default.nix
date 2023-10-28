{ lib
, buildPythonPackage
, fetchFromGitHub
, safetensors
, accelerate
, rouge
, peft
, transformers
, datasets
, torch
, cudaPackages
, rocmPackages
, symlinkJoin
, which
, ninja
, pybind11
, gcc11Stdenv
}:

let
  cuda-native-redist = symlinkJoin {
    name = "cuda-redist";
    paths = with cudaPackages; [
      cuda_cudart # cuda_runtime.h
      cuda_nvcc
    ];
  };
in

buildPythonPackage {
  pname = "autogptq";
  version = "0.4.2";
  format = "setuptools";

  BUILD_CUDA_EXT = "1";

  CUDA_HOME = cuda-native-redist;
  CUDA_VERSION = cudaPackages.cudaVersion;

  buildInputs = [
    pybind11
    cudaPackages.cudatoolkit
  ];

  preBuild = ''
    export PATH=${gcc11Stdenv.cc}/bin:$PATH
  '';

  nativeBuildInputs = [
    which
    ninja
    rocmPackages.clr
  ];

  src = fetchFromGitHub {
    owner = "PanQiWei";
    repo = "AutoGPTQ";
    rev = "51c043c6bef1380e121474ad73ea2a22f2fb5737";
    hash = "sha256-O/ox/VSMgvqK9SWwlaz8o12fLkz9591p8CVC3e8POQI=";
  };

  pythonImportsCheck = [ "auto_gptq" ];

  propagatedBuildInputs = [
    safetensors
    accelerate
    rouge
    peft
    transformers
    datasets
    torch
  ];

  meta = with lib; {
    description = "An easy-to-use LLMs quantization package with user-friendly apis, based on GPTQ algorithm";
    homepage = "https://github.com/PanQiWei/AutoGPTQ";
    license = licenses.mit;
    maintainers = [ ];
  };
}
