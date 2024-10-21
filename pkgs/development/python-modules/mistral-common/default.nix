{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pytestCheckHook,
  pydantic,
  jsonschema,
  sentencepiece,
  typing,
  tiktoken,
  pillow,
  requests,
  numpy,
}:

buildPythonPackage rec {
  pname = "mistral-common";
  version = "1.4.4";
  pyproject = true;

  src = fetchPypi {
    pname = "mistral_common";
    inherit version;
    hash = "sha256-EQ4bk3rumf3PPO/GtOkk5+Iv9EUkYJD+khUFEkXKpZw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pydantic
    jsonschema
    sentencepiece
    typing
    tiktoken
    pillow
    requests
    numpy
  ];

  doCheck = true;

  meta = with lib; {
    description = "mistral-common is a set of tools to help you work with Mistral models.";
    homepage = "https://github.com/mistralai/mistral-common";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
