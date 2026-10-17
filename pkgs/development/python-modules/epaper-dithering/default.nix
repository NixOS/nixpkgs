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
  version = "6.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenDisplay";
    repo = "epaper-dithering";
    tag = "epaper-dithering-v${finalAttrs.version}";
    hash = "sha256-rKf8sM9F0qk2sw7HHyUo0A68ttIBlXeXNThts4BFSRo=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-KjG9DDx3zngJKkTvfGfeAdSQ6unEBfvy3xdc/Xg2mFs=";
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
