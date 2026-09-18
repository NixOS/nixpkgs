{
  lib,
  buildPythonPackage,
  fetchPypi,
  # Python Inputs
  setuptools,
  ipywidgets,
}:

buildPythonPackage rec {
  pname = "ipyvue";
  version = "1.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QIteamTiA/xnn0R6Bx49vBeKspBpgvJIrfci/IR3P/o=";
  };

  build-system = [ setuptools ];

  dependencies = [ ipywidgets ];

  doCheck = false; # No tests in package or GitHub
  pythonImportsCheck = [ "ipyvue" ];

  meta = {
    description = "Jupyter widgets base for Vue libraries";
    homepage = "https://github.com/mariobuikhuizen/ipyvue";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
