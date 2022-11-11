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
  version = "5.1.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    pname = "jaraco.test";
    inherit version;
    sha256 = "04a7503c0c78cd057bd6b5f16ad1e3379b911b619df6694480a564ebc214c0a8";
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
