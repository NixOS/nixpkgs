{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  asttokens,
  colorama,
  executing,
  pygments,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "icecream";
  version = "2.1.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WHVeWDl9U1CnbyWXbe57YH9f67PG4c3f5rGVGJbpFXM=";
  };

  postPatch = ''
    substituteInPlace tests/test_icecream.py \
      --replace assertRegexpMatches assertRegex
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    asttokens
    colorama
    executing
    pygments
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # icecream.icecream.NoSourceAvailableError
    "testSingledispatchArgumentToString"
    # AssertionError: assert [[('REPL (e.g...ion?', None)]] == [[('a', '1')], [('c', '3')]]
    "testEnableDisable"
  ];

  meta = with lib; {
    description = "Little library for sweet and creamy print debugging";
    homepage = "https://github.com/gruns/icecream";
    license = licenses.mit;
    maintainers = with maintainers; [ renatoGarcia ];
  };
}
