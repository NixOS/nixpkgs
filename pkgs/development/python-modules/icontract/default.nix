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
, fetchpatch
, deal
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "icontract";
  version = "2.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Parquery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NUgMt/o9EpSQyOiAhYBVJtQKJn0Pd2lI45bKlo2z7mk=";
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
    astor
    asyncstdlib
    docutils
    dpcontracts
    numpy
    pytestCheckHook
    py-cpuinfo
    pygments
    tabulate
    typeguard
    yapf
  ] ++ lib.optionals (pythonOlder "3.10") [
    deal
  ];

  disabledTestPaths = [
    # mypy decorator checks don't pass. For some reaseon mypy
    # doesn't check the python file provided in the test.
    "tests/test_mypy_decorators.py"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    # test requires deal which is not compatible with python 3.10 due to
    # pyschemes dependency
    "tests_with_others/test_deal.py"
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
