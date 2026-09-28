{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  cargo,
}:

buildPythonPackage rec {
  pname = "pysequoia";
  version = "0.1.35";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m2l7esurlIWnqM+hMPh/Y/jkodZU7ogwWxl+HLrhPco=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-dfmNYKWjfL6WbI8UFMCM7YE6Cy9oOusPNbZNCjD8o10=";
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
