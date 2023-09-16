{ lib
, astroid
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools-scm
, six
}:

buildPythonPackage rec {
  pname = "asttokens";
  version = "2.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LgFxuZGyyVmsxsSTGASSNoRKXaHWW6JnLEiAwciUg04=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    astroid
    pytestCheckHook
  ];

  disabledTests = [
    # Test is currently failing on Hydra, works locally
    "test_slices"
  ];

  pythonImportsCheck = [
    "asttokens"
  ];

  meta = with lib; {
    description = "Annotate Python AST trees with source text and token information";
    homepage = "https://github.com/gristlabs/asttokens";
    license = licenses.asl20;
    maintainers = with maintainers; [ leenaars ];
  };
}
