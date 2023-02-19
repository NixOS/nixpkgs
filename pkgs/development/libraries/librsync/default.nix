{ lib, stdenv, fetchFromGitHub, cmake, perl, zlib, bzip2, popt }:

stdenv.mkDerivation rec {
  pname = "librsync";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "librsync";
    repo = "librsync";
    rev = "v${version}";
    sha256 = "sha256-fiOby8tOhv0KJ+ZwAWfh/ynqHlYC9kNqKfxNl3IhzR8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl zlib bzip2 popt ];

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  meta = with lib; {
    description = "Implementation of the rsync remote-delta algorithm";
    homepage = "https://librsync.sourceforge.net/";
    changelog = "https://github.com/librsync/librsync/releases/tag/v${version}";
    license = licenses.lgpl2Plus;
    mainProgram = "rdiff";
    platforms = platforms.unix;
  };
}
