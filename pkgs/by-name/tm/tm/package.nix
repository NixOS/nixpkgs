{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAtts: {
  pname = "tm";
  version = "0.4.1";

  src = fetchurl {
    url = "https://vicerveza.homeunix.net/~viric/soft/tm/tm-${finalAtts.version}.tar.gz";
    hash = "sha256-OzibwDtpZK1f+lejRLiR/bz3ybJgSt2nI6hj+DZXxKA=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  patches = [
    # fix using strncpy and strlen without including string.h
    ./missing-string-header.patch
  ];

  postPatch = ''
    sed -i 's@/usr/bin/install@install@g ; s/gcc/cc/g' Makefile
  '';

  meta = {
    description = "Terminal mixer - multiplexer for the i/o of terminal applications";
    homepage = "http://vicerveza.homeunix.net/~viric/soft/tm";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "tm";
  };
})
