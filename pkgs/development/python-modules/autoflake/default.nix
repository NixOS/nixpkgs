{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pyflakes
, pytestCheckHook
, pythonOlder
, tomli
}:
buildPythonPackage rec {
  pname = "autoflake";
  version = "2.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jCAR+jRwG519zwW5hzvEhZ1Pzk5i3+qQ3/79FXb18B0=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pyflakes
  ]
  ++ lib.optional (pythonOlder "3.11") tomli;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "autoflake"
  ];

  disabledTests = [
    # AssertionError: True is not false
    "test_is_literal_or_name"
  ];

  meta = with lib; {
    description = "Tool to remove unused imports and unused variables";
    homepage = "https://github.com/myint/autoflake";
    license = licenses.mit;
    maintainers = with maintainers; [ yuriaisaka ];
  };
}
