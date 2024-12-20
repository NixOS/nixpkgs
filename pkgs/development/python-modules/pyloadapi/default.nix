{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-regex-commit,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyloadapi";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "pyloadapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-USSTXHHhtUc8QF9U3t3rARXn5Iqo6KOGBa3VAfRMbiQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--cov=src/pyloadapi/ --cov-report=term-missing" ""
  '';

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
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
    changelog = "https://github.com/tr4nt0r/pyloadapi/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
