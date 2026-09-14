{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "loro";
  version = "1.13.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DDcnvFL1CYV2Uy7dOZ78CM6yNMXZI1oZy9XqN8T7pIU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-KVBe2bUvxilOysCVfcBSZCtwexlTkVAc83tH1H7nMbQ=";
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
