{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pyflakes
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "autoflake";
  version = "2.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HOUgExt/OWkVJC/pHlciH01CQIUpu+Ouk62v7ShlkeA=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pyflakes
  ];

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
