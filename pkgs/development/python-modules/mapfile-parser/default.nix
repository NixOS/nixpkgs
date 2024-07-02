{
  lib,
  python3,
  fetchPypi,
  cargo,
  rustPlatform,
  rustc,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "mapfile-parser";
  version = "2.4.0";
  pyproject = true;

  src = fetchPypi {
    pname = "mapfile_parser";
    inherit version;
    hash = "sha256-Y1iu+c6m7mhY7MJcHDMtBqJzFD7bMz4QV1pIjN1K7w8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-mETYML73/L8dcUj0tlydO8xe4ye9JF8tjIDMF1dYCeE=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  propagatedBuildInputs = with python3.pkgs; [ requests ];

  meta = {
    description = "Map file parser library focusing decompilation projects";
    homepage = "https://pypi.org/project/mapfile-parser/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qubitnano ];
  };
}
