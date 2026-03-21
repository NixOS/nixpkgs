{
  lib,
  buildPythonPackage,
  colorthief,
  fetchFromGitHub,
  nix-update-script,
  pillow,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "modern-colorthief";
  version = "0.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "baseplate-admin";
    repo = "modern_colorthief";
    tag = version;
    hash = "sha256-8V4S2VdtKnkH9HcY10KtkZXhjMRjPslETFeveFEDFCM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-n5qIlkLvRpIeCG2rr1N0s7n3PTUOesg6PHqIppSaqiM=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  optional-dependencies = {
    test = [
      colorthief
      pillow
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    # Requires `fast_colorthief`, which isn't packaged
    "examples/test_time.py"
  ];

  pythonImportsCheck = [ "modern_colorthief" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://modern-colorthief.readthedocs.io/";
    changelog = "https://github.com/baseplate-admin/modern_colorthief/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
