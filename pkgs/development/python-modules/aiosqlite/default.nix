{ lib
, aiounittest
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiosqlite";
  version = "0.19.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "omnilib";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dm7uqG59FP40hcQt+R7qfQiD8P42AYZ2WcH1RoEC5wQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    aiounittest
    pytestCheckHook
  ];

  # Tests are not pick-up automatically by the hook
  pytestFlagsArray = [
    "aiosqlite/tests/*.py"
  ];

  pythonImportsCheck = [
    "aiosqlite"
  ];

  meta = with lib; {
    description = "Asyncio bridge to the standard sqlite3 module";
    homepage = "https://github.com/jreese/aiosqlite";
    changelog = "https://github.com/omnilib/aiosqlite/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
