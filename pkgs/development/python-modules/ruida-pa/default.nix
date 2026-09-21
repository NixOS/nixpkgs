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
  version = "0.20.4";
  pyproject = true;

  src = fetchPypi {
    pname = "ruida_pa";
    inherit version;
    hash = "sha256-qvIdg0qkOmIn0ydapleONZHazueO6jzcB+PpsuiW02w=";
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
