{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, filelock
, huggingface-hub
, importlib-metadata
, numpy
, pillow
, regex
, requests
, safetensors
}:

buildPythonPackage rec {
  pname = "diffusers";
  version = "0.23.1";

  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ospWvOU8f4/Cnn46rgrx2/XXdtmvx8k3+wHJXBeJ2gM=";
  };

  propagatedBuildInputs = [
    setuptools
    filelock
    huggingface-hub
    importlib-metadata
    numpy
    pillow
    regex
    requests
    safetensors
  ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Diffusers: State-of-the-art diffusion models for image and audio generation in PyTorch";
    homepage = "https://github.com/huggingface/diffusers";
    license = licenses.asl20;
    maintainers = with maintainers; [ felixsanz ];
  };
}
