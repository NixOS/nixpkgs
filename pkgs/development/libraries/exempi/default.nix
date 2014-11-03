{ stdenv, fetchurl, expat, zlib, boost }:

stdenv.mkDerivation rec {
  name = "exempi-2.2.2";

  src = fetchurl {
    url = "http://libopenraw.freedesktop.org/download/${name}.tar.bz2";
    sha256 = "01vcd1mfn2s0iiq2cjyzgvnxx6kcq9cwra1iipijhs0vwvjx0yhf";
  };

  configureFlags = [ "--with-boost=${boost.dev}" ];

  buildInputs = [ expat zlib boost ];

  meta = with stdenv.lib; {
    homepage = http://libopenraw.freedesktop.org/wiki/Exempi/;
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
