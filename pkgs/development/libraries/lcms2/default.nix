{stdenv, fetchurl, libtiff, libjpeg, zlib}:

stdenv.mkDerivation rec {
  name = "lcms2-2.5";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${name}.tar.gz";
    sha256 = "1vyjsvld0881n5vrvw3bcxiqmn7yyy6j1yj1nz76ksaxkarschnk";
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
