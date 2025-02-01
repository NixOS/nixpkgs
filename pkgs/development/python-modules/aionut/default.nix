{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aionut";
  version = "4.3.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aionut";
    tag = "v${version}";
    hash = "sha256-DCWfa5YfrB7MTf78AeSHDgiZzLNXoiNLnty9a+Sr9tQ=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aionut" ];

  meta = with lib; {
    description = "Asyncio Network UPS Tools";
    homepage = "https://github.com/bdraco/aionut";
    changelog = "https://github.com/bdraco/aionut/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
