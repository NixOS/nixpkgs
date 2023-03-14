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
  version = "6.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AATsUNcYLB4vtyvuooAMDZx8p5fayijb6yJoUKTCW40=";
  };

  patches = [
    # TODO: remove on next release
    (fetchpatch {
      name = "fix-mistake-in-menu-group-specification.patch";
      url = "https://github.com/enthought/envisage/commit/f23ea3864a5f6ffca665d47dec755992e062029b.patch";
      sha256 = "sha256-l4CWB4jRkSmoTDoV8CtP2w87Io2cLINKfOSaSPy7cXE=";
    })
  ];

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
