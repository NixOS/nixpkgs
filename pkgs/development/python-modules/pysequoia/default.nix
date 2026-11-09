{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  cargo,
}:

buildPythonPackage rec {
  pname = "pysequoia";
  version = "0.1.36";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Pj+NHgA87Av3tDfWn2WcPUrnhKwosFlYDvh/tW6ACdk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-u6v48wj3kqV/15zbeePuvIpZBxcUg9DU6G1Zmz5SYUU=";
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
