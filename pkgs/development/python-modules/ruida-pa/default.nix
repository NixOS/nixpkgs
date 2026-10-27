{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bokeh,
  pyserial,
  rpyc,
  textual,
}:

buildPythonPackage rec {
  pname = "ruida-pa";
  version = "0.22.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ruida_pa";
    inherit version;
    hash = "sha256-+O1lB9N5xPWU5EZRkj6Eo54Vvp6H4h/GdXUt1rWJesc=";
  };

  build-system = [ setuptools ];

  # Upstream wants bokeh >= 3.9; nixpkgs is on 3.8.x and rayforge does not use
  # the bokeh-backed visualisation.
  pythonRelaxDeps = [ "bokeh" ];

  dependencies = [
    bokeh
    pyserial
    rpyc
    textual
  ];

  # The distribution is named ruida-pa but installs the ruidadriver package.
  pythonImportsCheck = [ "ruidadriver" ];

  meta = {
    description = "Analyzer for the binary Ruida CNC controller protocol";
    homepage = "https://github.com/StevenIsaacs/ruida-pa";
    license = lib.licenses.mit;
    mainProgram = "rpa";
    maintainers = with lib.maintainers; [ kanagawamarcos ];
  };
}
