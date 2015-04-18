{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdvdcss-1.3.0";
  
  src = fetchurl {
    url = http://download.videolan.org/pub/libdvdcss/1.3.0/libdvdcss-1.3.0.tar.bz2;
    sha256 = "158k9zagmbk5bkbz96l6lwhh7xcgfcnzflkr4vblskhcab6llhbw";
  };

  meta = {
    homepage = http://www.videolan.org/developers/libdvdcss.html;
    description = "A library for decrypting DVDs";
  };
}
