{ stdenv, fetchFromGitHub, cmake, perl, zlib, bzip2, popt }:

stdenv.mkDerivation rec {
  name = "librsync-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "librsync";
    repo = "librsync";
    rev = "v${version}";
    sha256 = "1qnr4rk93mhggqjh2025clmlhhgnjhq983p1vbh8i1g8aiqdnapi";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl zlib bzip2 popt ];

  crossAttrs = {
    dontStrip = true;
  };

  meta = with stdenv.lib; {
    homepage = http://librsync.sourceforge.net/;
    license = licenses.lgpl2Plus;
    description = "Implementation of the rsync remote-delta algorithm";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
