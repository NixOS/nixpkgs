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
  version = "1.5.2";
  pyproject = true;

  src = fetchPypi {
    pname = "mistral_common";
    inherit version;
    hash = "sha256-nRFXsTdsSdNav8dD2+AITyyjezpavQPnQSdqG8ZshS8=";
  };

  # relax dependencies
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'pillow = "^10.3.0"' 'pillow = ">=10.3.0"' \
      --replace-fail 'tiktoken = "^0.7.0"' 'tiktoken = ">=0.7.0"' \
  '';

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
    description = "mistral-common is a set of tools to help you work with Mistral models.";
    homepage = "https://github.com/mistralai/mistral-common";
    license = licenses.asl20;
    maintainers = with maintainers; [ bgamari ];
  };
}
