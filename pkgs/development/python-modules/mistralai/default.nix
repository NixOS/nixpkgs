{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  poetry-core,
  eval-type-backport,
  httpx,
  pydantic,
  python-dateutil,
  typing-inspection,
}:
buildPythonPackage rec {
  pname = "mistralai";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "client-python";
    tag = "v${version}";
    hash = "sha256-GYA0gtLIdYrGoUaPQvKYaI/CkDGZfW9aYZa2pAd0R7Y=";
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

  pythonImportsCheck = [
    "mistralai"
  ];

  # pyproject.toml assumes README-PYPI.md is present
  preBuild = ''
    cp README.md README-PYPI.md
  '';

  meta = {
    description = "MistralAi Python SDK";
    homepage = "https://github.com/mistralai/client-python";
    changelog = "https://github.com/mistralai/client-python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jbr ];
  };
}
