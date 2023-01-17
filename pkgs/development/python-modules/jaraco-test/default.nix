{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, setuptools-scm
, toml
, jaraco_functools
, jaraco-context
, more-itertools
, jaraco_collections
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jaraco-test";
  version = "5.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "jaraco.test";
    inherit version;
    hash = "sha256-f2f8xTlTgXGCPlqp+dA04ulRLOTzVNEb39hNtytGHUA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    toml
    jaraco_functools
    jaraco-context
    more-itertools
    jaraco_collections
  ];

  checkInputs = [
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
