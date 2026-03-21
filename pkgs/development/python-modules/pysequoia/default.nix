{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  cargo,
}:

buildPythonPackage rec {
  pname = "pysequoia";
  version = "0.1.31";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1qvMoytvivcVkiBFB6wzt4ejxAbxCAOg+ENRtT8LtdE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-kr7Gqj4qQ6x/AOXaMoY4kBqP0q3iXLfpzyLQQDb0b8k=";
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
