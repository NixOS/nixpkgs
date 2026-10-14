{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "davey";
  version = "0.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Daxoxrqhy/0QSLh1JtKckYT+t9gXX13CQd80jEMHqMA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-3xgP0lZ/dhPOnGIjuYdXROvJogtHBuqAmqEKMWQ8YYo=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  pythonImportsCheck = [ "davey" ];

  meta = {
    description = "Implementation of Discord's audio and video end-to-end encryption (DAVE) protocol";
    homepage = "https://github.com/Snazzah/davey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ epwv ];
  };
}
