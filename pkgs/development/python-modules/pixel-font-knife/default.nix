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
  version = "0.0.11";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "pixel_font_knife";
    inherit version;
    hash = "sha256-tm5cAaeUBL9vbdvq73N2HCytlwYe0Q2Tovo+6XU59GQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pypng
    unidata-blocks
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pixel_font_knife" ];

  meta = with lib; {
    homepage = "https://github.com/TakWolf/pixel-font-knife";
    description = "Set of pixel font utilities";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [
      TakWolf
      h7x4
    ];
  };
}
