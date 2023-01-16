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

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    pname = "jaraco.test";
    inherit version;
    sha256 = "sha256-f2f8xTlTgXGCPlqp+dA04ulRLOTzVNEb39hNtytGHUA=";
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

  pythonImportsCheck = [ "jaraco.test" ];

  meta = {
    description = "Testing support by jaraco";
    homepage = "https://github.com/jaraco/jaraco.test";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
