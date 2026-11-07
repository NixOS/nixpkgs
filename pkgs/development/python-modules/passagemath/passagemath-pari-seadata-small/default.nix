{
  pkgs,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  passagemath-setup,
  passagemath-environment,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-pari-seadata-small";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    passagemath-setup
  ];
  buildInputs = with pkgs; [
    # No external libraries required.
  ];
  dependencies = [
    passagemath-environment
  ];

  src = fetchPypi {
    pname = "passagemath_pari_seadata_small";
    inherit version;
    hash = "sha256-b27PNbvH5xMUDWGfVcq9eWoVGzCW0s25GGtkFlOLLC4=";
  };
}
