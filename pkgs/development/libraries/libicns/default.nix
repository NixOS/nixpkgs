{ lib, stdenv, fetchgit, autoreconfHook, libpng, openjpeg, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libicns";
  version = "0.8.1-unstable-2022-04-10";

  src = fetchgit {
    url = "https://git.code.sf.net/p/icns/code";
    rev = "921f972c461c505e5ac981aaddbdfdde97e8bb2b";
    hash = "sha256-YeO0rlTujDNmrdJ3DRyl3TORswF2KFKA+wVUxJo8Dno=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libpng openjpeg ];

  meta = with lib; {
    description = "Library for manipulation of the Mac OS icns resource format";
    homepage = "https://icns.sourceforge.io";
    license = with licenses; [ gpl2 lgpl2 lgpl21 ];
    platforms = platforms.unix;
  };
}
