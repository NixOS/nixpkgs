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
  version = "0.16.2";
  pyproject = true;

  src = fetchPypi {
    pname = "kernels_data";
    inherit (finalAttrs) version;
    hash = "sha256-xFyIuMSbjYEwYVtep4tRYhtcXJTqR8kC1gAnUKvmEIo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-MVDCLYRu7aSFBlKRsaxck2M6k1eTR/bqcv8pFTvJoxw=";
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
