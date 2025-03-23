{
  lib,
  stdenv,
  fetchurl,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "wmname";
  version = "0.1";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/wmname-${version}.tar.gz";
    sha256 = "559ad188b2913167dcbb37ecfbb7ed474a7ec4bbcb0129d8d5d08cb9208d02c5";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "@strip" "#@strip"
  '';

  buildInputs = [ libX11 ];

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Prints or set the window manager name property of the root window";
    homepage = "https://tools.suckless.org/wmname";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "wmname";
  };
}
