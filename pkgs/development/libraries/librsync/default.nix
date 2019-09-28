{ stdenv, fetchFromGitHub, cmake, perl, zlib, bzip2, popt }:

stdenv.mkDerivation rec {
  pname = "librsync";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "librsync";
    repo = "librsync";
    rev = "v${version}";
    sha256 = "03ncx7a2zd93b3jaq7b62nwn8qcwmf04jfvljnpxj5wsxl2agkp7";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl zlib bzip2 popt ];

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  meta = with stdenv.lib; {
    homepage = http://librsync.sourceforge.net/;
    license = licenses.lgpl2Plus;
    description = "Implementation of the rsync remote-delta algorithm";
    platforms = platforms.unix;
  };
}
