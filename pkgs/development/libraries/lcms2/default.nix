{stdenv, fetchurl, libtiff, libjpeg, zlib}:

stdenv.mkDerivation rec {
  name = "lcms2-2.3";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${name}.tar.gz";
    sha256 = "1r5gmzhginzm90y70dcbamycdfcaz4f7v0bb4nwyaywlvsxpg89y";
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
