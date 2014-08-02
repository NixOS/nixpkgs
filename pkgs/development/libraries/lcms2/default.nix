{stdenv, fetchurl, libtiff, libjpeg, zlib}:

stdenv.mkDerivation rec {
  name = "lcms2-2.5";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${name}.tar.gz";
    sha256 = "0ax71bmscjzlpmg1r8vj3dypxf2jr7j9qfx5vc8j22j78hmpf9v7";
  };

  propagatedBuildInputs = [ libtiff libjpeg zlib ];

  meta = {
    description = "Color management engine";
    homepage = http://www.littlecms.com/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
