{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  numpy,
  pillow,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "epaper-dithering";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenDisplay";
    repo = "epaper-dithering";
    tag = "epaper-dithering-v${finalAttrs.version}";
    hash = "sha256-m0t+Zxd+a4Mc9QkdhOPSF72l9uxgaAFctoB60i6hcV8=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src sourceRoot;
    hash = "sha256-RBOULCydXgTR8Snc1cecvW4KqGDLYjZsYwlJovuvN2I=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    pillow
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "epaper_dithering" ];

  meta = {
    description = "Dithering algorithms for e-paper/e-ink displays";
    homepage = "https://github.com/OpenDisplay/epaper-dithering";
    changelog = "https://github.com/OpenDisplay/epaper-dithering/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
