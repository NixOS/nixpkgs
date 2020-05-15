{ stdenv, fetchFromGitHub, cmake, perl, zlib, bzip2, popt }:

stdenv.mkDerivation rec {
  pname = "librsync";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "librsync";
    repo = "librsync";
    rev = "v${version}";
    sha256 = "18wwfbbggsjrd4w3dczxa2gv3zvx0fqp68b8h1zzvdbyn91f16mz";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl zlib bzip2 popt ];

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  meta = with stdenv.lib; {
    homepage = "http://librsync.sourceforge.net/";
    license = licenses.lgpl2Plus;
    description = "Implementation of the rsync remote-delta algorithm";
    platforms = platforms.unix;
  };
}
