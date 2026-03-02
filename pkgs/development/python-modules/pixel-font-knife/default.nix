{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
  nix-update-script,
  hatchling,
  pypng,
  unidata-blocks,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pixel-font-knife";
  version = "0.0.21";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchPypi {
    pname = "pixel_font_knife";
    inherit version;
    hash = "sha256-QTwrxXn5uAp44D/rgbZiCaFP+rDU4H4LGw75n2hQJGs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pypng
    unidata-blocks
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pixel_font_knife" ];

  meta = {
    homepage = "https://github.com/TakWolf/pixel-font-knife";
    description = "Set of pixel font utilities";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      TakWolf
      h7x4
    ];
  };
}
