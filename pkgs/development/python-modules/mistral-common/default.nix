{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  numpy,
  pydantic,
  jsonschema,
  opencv-python-headless,
  sentencepiece,
  typing-extensions,
  tiktoken,
  pillow,
  requests,
}:

buildPythonPackage rec {
  pname = "mistral-common";
  version = "1.5.6";
  pyproject = true;

  src = fetchPypi {
    pname = "mistral_common";
    inherit version;
    hash = "sha256-TauSQwaEMhFKFfLEb/SRagViCnIrDfjetJ3POD+34r8=";
  };

  pythonRelaxDeps = [
    "pillow"
    "tiktoken"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    pydantic
    jsonschema
    opencv-python-headless
    sentencepiece
    typing-extensions
    tiktoken
    pillow
    requests
  ];

  doCheck = true;

  pythonImportsCheck = [ "mistral_common" ];

  meta = with lib; {
    description = "Tools to help you work with Mistral models";
    homepage = "https://github.com/mistralai/mistral-common";
    license = licenses.asl20;
    maintainers = with maintainers; [ bgamari ];
  };
}
