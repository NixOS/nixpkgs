{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "uisp";
  version = "20050207";

  src = fetchurl {
    url = "https://savannah.nongnu.org/download/uisp/uisp-${version}.tar.gz";
    sha256 = "1bncxp5yxh9r1yrp04vvhfiva8livi1pwic7v8xj99q09zrwahvw";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = {
    description = "Tool for AVR microcontrollers which can interface to many hardware in-system programmers";
    mainProgram = "uisp";
    license = lib.licenses.gpl2;
    homepage = "https://savannah.nongnu.org/projects/uisp";
    platforms = lib.platforms.linux;
  };
}
