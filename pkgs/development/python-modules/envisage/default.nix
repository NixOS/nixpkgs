{
  lib,
  apptools,
  buildPythonPackage,
  fetchPypi,
  pyface,
  pytestCheckHook,
  setuptools,
  traits,
  traitsui,
}:

buildPythonPackage rec {
  pname = "envisage";
  version = "7.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1rspOLu0XE7xdmxV7W9sHHK2/OcEaKyfWw780e+MHZc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    apptools
    pyface
    setuptools
    traits
    traitsui
  ]
  ++ apptools.optional-dependencies.preferences;

  preCheck = ''
    export HOME=$PWD/HOME
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "envisage" ];

  meta = {
    description = "Framework for building applications whose functionalities can be extended by adding plug-ins";
    homepage = "https://github.com/enthought/envisage";
    license = lib.licenses.bsdOriginal;
    maintainers = [ ];
  };
}
