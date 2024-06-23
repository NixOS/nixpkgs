{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  nix-update-script,
  hatch-vcs,
  hatchling,
  bdffont,
  brotli,
  fonttools,
  pypng,
  pcffont,
}:

buildPythonPackage rec {
  pname = "pixel-font-builder";
  version = "0.0.26";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "pixel_font_builder";
    inherit version;
    hash = "sha256-bgs2FbOA5tcUXe5+KuVztWGAv5yFxQNBaiZMeZ+ic+8=";
  };

  pythonRelaxDeps = [ "fonttools" ];


  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pypng
  ];

  dependencies = [
    bdffont
    brotli
    fonttools
    pcffont
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/pixel-font-builder";
    description = "Library that helps create pixel style fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}
