{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
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
  version = "5.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jaraco.test";
    inherit version;
    hash = "sha256-29NDh4dYrcVER9YRXEYXia2zH8QHOyEpUCQwk7oxfsI=";
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
    changelog = "https://github.com/jaraco/jaraco.test/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
