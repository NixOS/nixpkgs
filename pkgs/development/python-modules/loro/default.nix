{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "loro";
  version = "1.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DSBf7ojgNz+z3LzbIk0MKsq98/oHlumvGOy6xpn5ivs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-LDwERDWgoqlANa03t9bTYjInF4dPyJJ0cta+/jgS33I=";
  };

  build-system = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Data collaborative and version-controlled JSON with CRDTs";
    homepage = "https://github.com/loro-dev/loro-py";
    changelog = "https://github.com/loro-dev/loro-py/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dmadisetti
    ];
  };
}
