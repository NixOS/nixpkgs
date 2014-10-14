{stdenv, fetchurl, libtiff, libjpeg, zlib}:

stdenv.mkDerivation rec {
  name = "lcms2-2.6";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${name}.tar.gz";
    sha256 = "1c8lgq8gfs3nyplvbx9k8wzfj6r2bqi3f611vb1m8z3476454wji";
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
