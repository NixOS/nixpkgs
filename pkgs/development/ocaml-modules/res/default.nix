{ lib , fetchurl , buildDunePackage }:

buildDunePackage rec {
  pname = "res";
  version = "5.0.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mmottl/res/releases/download/${version}/res-${version}.tbz";
    hash = "sha256-rSrDMQBfnbWAr2LuajP3fveOtOwLyRbKPkaTKsnocQ4=";
  };

  doCheck = true;

  meta = {
    description = "Library for resizable, contiguous datastructures";
    homepage = "https://github.com/mmottl/res";
    changelog = "https://github.com/mmottl/res/blob/${version}/CHANGES.md";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ sixstring982 ];
  };
}

