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
  version = "5.2.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    pname = "jaraco.test";
    inherit version;
    sha256 = "sha256-K1OYx58TriCKoGfdLlEw3ArC699DR5w9r7bxLz2bdIs=";
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
