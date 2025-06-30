{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-regex-commit,
  hatchling,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  python-dotenv,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyloadapi";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "pyloadapi";
    tag = "v${version}";
    hash = "sha256-DkYbQB91KYskfm2yDVmR0/MJiixC2C5miHpTq7RpVBU=";
  };

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    python-dotenv
  ];

  pythonImportsCheck = [ "pyloadapi" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_cli.py"
  ];

  meta = with lib; {
    description = "Simple wrapper for pyLoad's API";
    homepage = "https://github.com/tr4nt0r/pyloadapi";
    changelog = "https://github.com/tr4nt0r/pyloadapi/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
