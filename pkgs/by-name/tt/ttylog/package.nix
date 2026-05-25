{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ttylog";
  version = "0.31";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "mirror://sourceforge/project/ttylog/ttylog/${finalAttrs.version}/ttylog-${finalAttrs.version}.tar.gz";
    hash = "sha256-En4uG+vRm1MgZ/ZY55TBLG37JWvwEQvlihyW/EQsEJY=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://ttylog.sourceforge.net";
    description = "Simple serial port logger";
    longDescription = ''
      A serial port logger which can be used to print everything to stdout
      that comes from a serial device.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ttylog";
  };
})
