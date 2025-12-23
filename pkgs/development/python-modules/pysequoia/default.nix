{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  cargo,
}:

buildPythonPackage rec {
  pname = "pysequoia";
  version = "0.1.29";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PWzXXBAKrVZaFtZCYOyMHX5DIickqN9eR6DYhDNBoJo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-sZTbPlfkZLWcRmdOWLBw8k0pIukAjQ53C8Zs9gLEW+I=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
  ];

  pythonImportsCheck = [ "pysequoia" ];

  meta = {
    description = "This library provides OpenPGP facilities in Python through the Sequoia PGP library";
    downloadPage = "https://github.com/wiktor-k/pysequoia";
    homepage = "https://github.com/wiktor-k/pysequoia";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
