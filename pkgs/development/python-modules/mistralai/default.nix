{
  fetchPypi,
  buildPythonPackage,
  poetry-core,
  eval-type-backport,
  httpx,
  pydantic,
  python-dateutil,
  typing-inspection,
  lib,
}:
buildPythonPackage rec {
  pname = "mistralai";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lOPrI8HT7TmKlTUgYv2Mkpk8w3VO0Y6aNbYKo9sL0QM=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    eval-type-backport
    httpx
    pydantic
    python-dateutil
    typing-inspection
  ];

  meta = {
    description = "MistralAi Python SDK";
    homepage = "https://github.com/mistralai/client-python";
    changelog = "https://github.com/mistralai/client-python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [jbr];
  };
}
