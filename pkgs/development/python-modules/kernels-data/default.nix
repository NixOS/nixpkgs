{
  lib,
  buildPythonPackage,
  fetchPypi,
  cargo,
  rustPlatform,
  rustc,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "kernels-data";
  version = "0.16.1";
  pyproject = true;

  src = fetchPypi {
    pname = "kernels_data";
    inherit (finalAttrs) version;
    hash = "sha256-fcgEpfXyuJA6LwfZb2yMQopTnV2ibH+R6Wh6OOGbPxI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ItMTFRgAk+hthmOsNVIlBIQReiY5ZMviR1Zp8pzL2QA=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonImportsCheck = [ "kernels_data" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kernels data structures";
    homepage = "https://pypi.org/project/kernels-data";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
