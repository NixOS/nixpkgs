{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aionut";
  version = "4.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aionut";
    tag = "v${version}";
    hash = "sha256-mpWAxv6RUTecGp6Zdka+gC+12JWcPQaKgJlqGgEINu0=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aionut" ];

  meta = {
    description = "Asyncio Network UPS Tools";
    homepage = "https://github.com/bdraco/aionut";
    changelog = "https://github.com/bdraco/aionut/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
