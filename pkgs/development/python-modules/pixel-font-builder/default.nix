{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, nix-update-script
, hatch-vcs
, hatchling
, bdffont
, brotli
, fonttools
, pypng
}:

buildPythonPackage rec {
  pname = "pixel-font-builder";
  version = "0.0.10";

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "pixel_font_builder";
    inherit version;
    hash = "sha256-evLsNRSC9sPZfhNc8tYbZ/bIrBxSbLuiGRD3ld7Jkbo=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pypng
  ];

  propagatedBuildInputs = [
    bdffont
    brotli
    fonttools
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/TakWolf/pixel-font-builder";
    description = "A library that helps create pixel style fonts";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}
