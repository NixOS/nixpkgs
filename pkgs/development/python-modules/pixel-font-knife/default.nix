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
  version = "0.0.13";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "pixel_font_knife";
    inherit version;
    hash = "sha256-zHLIB46GwNqq1KqZ/AKyc2g3tU7v1nxEgyjlt9lMPgA=";
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
