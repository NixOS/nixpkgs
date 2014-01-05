{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libunibreak-${version}";
  version = "1.1";

  src = fetchurl {
    url = "mirror://sourceforge/vimgadgets/libunibreak/${version}/${name}.tar.gz";
    sha256 = "02657l426bk5d8h42b9ixxy1clc50mx4bzwg02nkdhs09wqw32wn";
  };

  meta = with stdenv.lib; {
    homepage = http://vimgadgets.sourceforge.net/libunibreak/;
    description = "A library implementing a line breaking algorithm as described in Unicode 6.0.0 Standard";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainer = [ maintainers.coroa ];
  };
}
