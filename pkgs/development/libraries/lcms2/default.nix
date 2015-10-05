{ stdenv, fetchurl, libtiff, libjpeg, zlib }:

stdenv.mkDerivation rec {
  name = "lcms2-2.7";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${name}.tar.gz";
    sha256 = "0lvaglcjsvnyglgj3cb3pjc22nq8fml1vlx5dmmmw66ywx526925";
  };

  outputs = [ "dev" "out" "bin" ];

  propagatedBuildInputs = [ libtiff libjpeg zlib ];

  meta = with stdenv.lib; {
    description = "Color management engine";
    homepage = http://www.littlecms.com/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
