{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pillow,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "epaper-dithering";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenDisplay";
    repo = "epaper-dithering";
    tag = "epaper-dithering-v${finalAttrs.version}";
    hash = "sha256-dumfngbwhhodLiPS6dDI/wjEXz8PD4FT2W8ADVJjeuY=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-KXEDtl4k08jco8sG7cS9yM3iJkKWKZNF5Fb9+wHxhyc=";
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
