{ stdenv, fetchFromGitHub, cmake, perl, zlib, bzip2, popt }:

stdenv.mkDerivation rec {
  name = "librsync-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "librsync";
    repo = "librsync";
    rev = "v${version}";
    sha256 = "0yad7nkw6d8j824qkxrj008ak2wq6yw5p894sbhr35yc1wr5mki6";
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
