{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools-scm,
  toml,
  jaraco-functools,
  jaraco-context,
  more-itertools,
  jaraco-collections,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jaraco-test";
  version = "5.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.test";
    rev = "refs/tags/v${version}";
    hash = "sha256-jbnU6PFVUd/eD9CWHyJvaTFkcZaIIwztkN9UbQZH1RU=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    toml
    jaraco-functools
    jaraco-context
    more-itertools
    jaraco-collections
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # https://github.com/jaraco/jaraco.test/issues/6
    "jaraco/test/cpython.py"
  ];

  pythonImportsCheck = [ "jaraco.test" ];

  meta = with lib; {
    description = "Testing support by jaraco";
    homepage = "https://github.com/jaraco/jaraco.test";
    changelog = "https://github.com/jaraco/jaraco.test/blob/${src.rev}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
