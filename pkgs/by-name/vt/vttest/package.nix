{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vttest";
  version = "20251205";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/vttest/vttest-${finalAttrs.version}.tgz"
      "https://invisible-island.net/archives/vttest/vttest-${finalAttrs.version}.tgz"
    ];
    sha256 = "sha256-zWiG+a7+aj9sVm+mEnGlVxCQGnGEnGML9TdqqYS/d8w=";
  };

  meta = {
    description = "Tests the compatibility of so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "vttest";
  };
})
