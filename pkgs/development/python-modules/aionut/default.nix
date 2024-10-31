{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
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
    rev = "refs/tags/v${version}";
    hash = "sha256-DCWfa5YfrB7MTf78AeSHDgiZzLNXoiNLnty9a+Sr9tQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=aionut --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  nativeCheckInputs = [
    pytest-asyncio
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
