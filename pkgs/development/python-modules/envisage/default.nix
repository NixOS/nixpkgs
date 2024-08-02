{
  lib,
  apptools,
  buildPythonPackage,
  fetchPypi,
  pyface,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  traits,
  traitsui,
}:

buildPythonPackage rec {
  pname = "envisage";
  version = "7.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-97GviL86j/8qmsbja7SN6pkp4/YSIEz+lK7WKwMWyeM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    apptools
    pyface
    setuptools
    traits
    traitsui
  ] ++ apptools.optional-dependencies.preferences;

  preCheck = ''
    export HOME=$PWD/HOME
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "envisage" ];

  meta = with lib; {
    description = "Framework for building applications whose functionalities can be extended by adding plug-ins";
    homepage = "https://github.com/enthought/envisage";
    license = licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ knedlsepp ];
  };
}
