{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, setuptools-scm
, toml
, jaraco-functools
, jaraco-context
, more-itertools
, jaraco-collections
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jaraco-test";
  version = "5.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "jaraco.test";
    inherit version;
    hash = "sha256-29NDh4dYrcVER9YRXEYXia2zH8QHOyEpUCQwk7oxfsI=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    toml
    jaraco-functools
    jaraco-context
    more-itertools
    jaraco-collections
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jaraco.test"
  ];

  meta = with lib; {
    description = "Testing support by jaraco";
    homepage = "https://github.com/jaraco/jaraco.test";
    changelog = "https://github.com/jaraco/jaraco.test/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
