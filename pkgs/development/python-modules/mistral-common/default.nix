{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  pydantic,
  jsonschema,
  opencv-python-headless,
  huggingface-hub,
  sentencepiece,
  typing-extensions,
  tiktoken,
  pillow,
  requests,
}:

buildPythonPackage rec {
  pname = "mistral-common";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "mistral_common";
    inherit version;
    hash = "sha256-Qv/lOBUruLLrAOsfiSeBbfHPSEBamfiEQ25BdsXY/iY=";
  };

  pythonRelaxDeps = [
    "pillow"
    "tiktoken"
  ];

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pydantic
    jsonschema
    opencv-python-headless
    huggingface-hub
    sentencepiece
    typing-extensions
    tiktoken
    pillow
    requests
  ];

  doCheck = true;

  pythonImportsCheck = [ "mistral_common" ];

  meta = with lib; {
    description = "mistral-common is a set of tools to help you work with Mistral models.";
    homepage = "https://github.com/mistralai/mistral-common";
    license = licenses.asl20;
    maintainers = with maintainers; [ bgamari ];
  };
}
