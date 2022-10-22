{ lib, stdenv, fetchFromGitHub, cmake, perl, zlib, bzip2, popt }:

stdenv.mkDerivation rec {
  pname = "librsync";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "librsync";
    repo = "librsync";
    rev = "v${version}";
    sha256 = "sha256-GNwOIZ2UjvsYIthotiPDBrabYzCGFG/YVEbwVa9Nwi4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl zlib bzip2 popt ];

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  meta = with lib; {
    description = "Implementation of the rsync remote-delta algorithm";
    homepage = "http://librsync.sourceforge.net/";
    license = licenses.lgpl2Plus;
    mainProgram = "rdiff";
    platforms = platforms.unix;
  };
}
