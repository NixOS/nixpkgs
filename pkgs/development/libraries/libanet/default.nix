{ lib, stdenv, fetchurl, gnat, gprbuild, glibc }:

stdenv.mkDerivation rec {
  pname = "libanet";
  version = "0.4.3";

  src = fetchurl {
    url = "https://www.codelabs.ch/download/${pname}-${version}.tar.bz2";
    hash = "sha256-8rQdjng/vHOnMZNjmOSp7mCU45kQmYbeqOLcZEv/abU=";
  };

  nativeBuildInputs = [
    gprbuild
    gnat
  ];

  makeFlags = [
    "PREFIX="
    "DESTDIR=${placeholder "out"}"
  ];

  dontConfigure = true;

  meta = {
    homepage = "https://www.codelabs.ch/anet/";
    description = "Anet is a networking library for the Ada programming language.";
    platforms = lib.platforms.all;
    license = lib.licenses.free; #this software uses the GNAT Modified General Public License (GMGPL)
    maintainers = with lib.maintainers; [ orichter thillux ];
  };
}
