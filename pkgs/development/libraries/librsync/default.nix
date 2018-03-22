{ stdenv, fetchFromGitHub, cmake, perl, zlib, bzip2, popt }:

stdenv.mkDerivation rec {
  name = "librsync-${version}";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "librsync";
    repo = "librsync";
    rev = "v${version}";
    sha256 = "0wihjinqbjl4hnvrgsk4ca1zy5v6bj7vjm6wlygwvgbn5yh3yq0x";
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
