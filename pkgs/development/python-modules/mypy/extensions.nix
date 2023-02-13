{ lib
, fetchFromGitHub
, buildPythonPackage
, typing
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mypy-extensions";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "python";
    repo = "mypy_extensions";
    rev = version;
    sha256 = "sha256-JjhbxX5DBAbcs1o2fSWywz9tot792q491POXiId+NyI=";
  };

  propagatedBuildInputs = lib.optional (pythonOlder "3.5") typing;

  # make the testsuite run with pytest, so we can disable individual tests
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/testextensions.py"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/python/mypy_extensions/issues/24
    "test_typeddict_errors"
  ];

  pythonImportsCheck = [
    "mypy_extensions"
  ];

  meta = with lib; {
    description = "Experimental type system extensions for programs checked with the mypy typechecker";
    homepage = "http://www.mypy-lang.org";
    license = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 SuperSandro2000 ];
  };
}
