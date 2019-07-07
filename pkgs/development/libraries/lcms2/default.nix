{ stdenv, fetchurl, libtiff, libjpeg, zlib }:

stdenv.mkDerivation rec {
  name = "lcms2-2.9";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${name}.tar.gz";
    sha256 = "083xisy6z01zhm7p7rgk4bx9d6zlr8l20qkfv1g29ylnhgwzvij8";
  };

  outputs = [ "bin" "dev" "out" ];

  propagatedBuildInputs = [ libtiff libjpeg zlib ];

  meta = with stdenv.lib; {
    description = "Color management engine";
    homepage = http://www.littlecms.com/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
