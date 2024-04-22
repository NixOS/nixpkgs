{ lib
, astor
, asttokens
, asyncstdlib
, buildPythonPackage
, deal
, dpcontracts
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "icontract";
  version = "2.6.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Parquery";
    repo = "icontract";
    rev = "refs/tags/v${version}";
    hash = "sha256-R5/FBfuTvXItfTlNZMSnO18Q+etnHbQyXFWpaOpOLes=";
  };

  preCheck = ''
    # we don't want to use the precommit.py script to build the package.
    # For the tests to succeed, "ICONTRACT_SLOW" needs to be set.
    # see https://github.com/Parquery/icontract/blob/aaeb1b06780a34b05743377e4cb2458780e808d3/precommit.py#L57
    export ICONTRACT_SLOW=1
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
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

  disabledTests = [
    # AssertionError
    "test_abstract_method_not_implemented"
  ];

  disabledTestPaths = [
    # mypy decorator checks don't pass. For some reason mypy
    # doesn't check the python file provided in the test.
    "tests/test_mypy_decorators.py"
    # Those tests seems to simply re-run some typeguard tests
    "tests/test_typeguard.py"
  ];

  pytestFlagsArray = [
    # RuntimeWarning: coroutine '*' was never awaited
    "-W" "ignore::RuntimeWarning"
  ];

  pythonImportsCheck = [
    "icontract"
  ];

  meta = with lib; {
    description = "Provide design-by-contract with informative violation messages";
    homepage = "https://github.com/Parquery/icontract";
    changelog = "https://github.com/Parquery/icontract/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ gador thiagokokada ];
  };
}
