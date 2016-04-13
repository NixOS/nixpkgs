{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libdvdcss-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdcss/${version}/${name}.tar.bz2";
    sha256 = "158k9zagmbk5bkbz96l6lwhh7xcgfcnzflkr4vblskhcab6llhbw";
  };

  meta = with stdenv.lib; {
    homepage = http://www.videolan.org/developers/libdvdcss.html;
    description = "A library for decrypting DVDs";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
