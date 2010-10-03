{stdenv, fetchurl, libtiff, libjpeg, zlib}:

stdenv.mkDerivation rec {
  name = "lcms2-2.0a";

  src = fetchurl {
    url = "mirror://sf/lcms/${name}.tar.gz";
    sha256 = "0kq5imagri0l964nnj06f7xny2q7rwvzqpm8ibsqz5zm263ggskd";
  };

  propagatedBuildInputs = [ libtiff libjpeg zlib ];

  meta = {
    description = "Color management engine";
    homepage = http://www.littlecms.com/;
    license = "MIT";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
