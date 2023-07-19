{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pytest-examples
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "dirty-equals";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-j+EqsKVRG2DDka1G3Px8ExYZt8QkqHkhojRnAHObdR4=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pytz
  ];

  nativeCheckInputs = [
    # pydantic - circular
    pytest-examples
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dirty_equals"
  ];

  disabledTestPaths = [
    # require pydantic
    "tests/test_other.py"
    "tests/test_docs.py"
  ];

  meta = with lib; {
    description = "Module for doing dirty (but extremely useful) things with equals";
    homepage = "https://github.com/samuelcolvin/dirty-equals";
    changelog = "https://github.com/samuelcolvin/dirty-equals/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
