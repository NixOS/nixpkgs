{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, asttokens
, typing-extensions
, pytestCheckHook
, yapf
, docutils
, pygments
, dpcontracts
, tabulate
, py-cpuinfo
, typeguard
, astor
, numpy
, asyncstdlib
}:

buildPythonPackage rec {
  pname = "icontract";
  version = "2.6.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Parquery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QyuegyjVyRLQS0DjBJXpTDNeBM7LigGJ5cztVOO7e3Y=";
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

  checkInputs = [
    pytestCheckHook
    yapf
    docutils
    pygments
    dpcontracts
    tabulate
    py-cpuinfo
    typeguard
    astor
    numpy
    asyncstdlib
  ];

  disabledTestPaths = [
    # needs an old version of deal to comply with the tests
    # see https://github.com/Parquery/icontract/issues/244
    "tests_with_others/test_deal.py"
    # mypy decorator checks don't pass. For some reaseon mypy
    # doesn't check the python file provided in the test.
    "tests/test_mypy_decorators.py"
  ];

  pythonImportsCheck = [ "icontract" ];

  meta = with lib; {
    description = "Provide design-by-contract with informative violation messages";
    homepage = "https://github.com/Parquery/icontract";
    changelog = "https://github.com/Parquery/icontract/blob/master/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
