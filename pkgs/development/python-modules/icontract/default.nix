{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, astor
, asttokens
, asyncstdlib
, deal
, dpcontracts
, numpy
, pytestCheckHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "icontract";
  version = "2.6.3";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Parquery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-kLi00Yf/UkSaBTvc+GlgTw263M2SMkyzADnQYLbsMfw=";
  };

  preCheck = ''
    # we don't want to use the precommit.py script to build the package.
    # For the tests to succeed, "ICONTRACT_SLOW" needs to be set.
    # see https://github.com/Parquery/icontract/blob/aaeb1b06780a34b05743377e4cb2458780e808d3/precommit.py#L57
    export ICONTRACT_SLOW=1
  '';

  propagatedBuildInputs = [
    asttokens
    typing-extensions
  ];

  nativeCheckInputs = [
    astor
    asyncstdlib
    deal
    dpcontracts
    numpy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # mypy decorator checks don't pass. For some reason mypy
    # doesn't check the python file provided in the test.
    "tests/test_mypy_decorators.py"
  ];

  pythonImportsCheck = [ "icontract" ];

  meta = with lib; {
    description = "Provide design-by-contract with informative violation messages";
    homepage = "https://github.com/Parquery/icontract";
    changelog = "https://github.com/Parquery/icontract/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ gador thiagokokada ];
  };
}
