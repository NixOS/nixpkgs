{ lib
, apptools
, buildPythonPackage
, fetchPypi
, fetchpatch
, ipython
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, setuptools
, traits
}:

buildPythonPackage rec {
  pname = "envisage";
  version = "7.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-97GviL86j/8qmsbja7SN6pkp4/YSIEz+lK7WKwMWyeM=";
  };

  # for the optional dependency ipykernel, only versions < 6 are
  # supported, so it's not included in the tests, and not propagated
  propagatedBuildInputs = [
    traits
    apptools
    setuptools
  ];

  preCheck = ''
    export HOME=$PWD/HOME
  '';

  nativeCheckInputs = [
    ipython
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/enthought/envisage/issues/455
    "envisage/tests/test_egg_basket_plugin_manager.py"
    "envisage/tests/test_egg_plugin_manager.py"
  ];

  pythonImportsCheck = [
    "envisage"
  ];

  meta = with lib; {
    description = "Framework for building applications whose functionalities can be extended by adding plug-ins";
    homepage = "https://github.com/enthought/envisage";
    license = licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ knedlsepp ];
  };
}
