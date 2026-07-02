{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  cargo,
}:

buildPythonPackage rec {
  pname = "pysequoia";
  version = "0.1.34";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pUJ+fMaV1NlcpOzcBqCdeYCe/XYd1Y9XdwKa1hBbU8k=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-qEn8+CySPwAV0zqbF4ooGsaXil7g6QJew7M+fbKsRqQ=";
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
