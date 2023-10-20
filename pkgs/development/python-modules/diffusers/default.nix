{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  # propagated build inputs
  pillow,
  filelock,
  huggingface-hub,
  importlib-metadata,
  numpy,
  regex,
  requests,
  safetensors,
  # optional dependencies
  torch,
  accelerate,
  jinja2,
  datasets,
  protobuf3,
  tensorboard,
}:
buildPythonPackage rec {
  pname = "diffusers";
  version = "0.21.4";

  disabled = pythonOlder "3.7.0"; # requires python version >=3.7.0

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P6w4gzF5Qn8WfGdd2nHue09eYnIARXqNUn5Aza+XJog=";
  };

  propagatedBuildInputs = [
    pillow
    filelock
    huggingface-hub
    importlib-metadata
    numpy
    regex
    requests
    safetensors
  ];

  passthru.optional-dependencies = {
    torch = [
      torch
      accelerate
    ];
    training = [
      jinja2
      accelerate
      datasets
      protobuf3
      tensorboard
    ];
  };

  # all tests rely on acess to the hugingface hub
  doCheck = false;
  pythonImportsCheck = [pname];

  meta = with lib; {
    description = "State-of-the-art diffusion in PyTorch and JAX";
    homepage = "https://github.com/huggingface/diffusers";
    license = licenses.asl20;
    maintainers = [maintainers.lizelive];
  };
}
