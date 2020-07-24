{ stdenv, fetchurl, libtiff, libjpeg, zlib }:

stdenv.mkDerivation rec {
  name = "lcms2-2.10";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${name}.tar.gz";
    sha256 = "0ipkw2r8h3yhm4vn5nx04dz5s943x9fw023fhrrnjz2c97yi3m2h";
  };

  outputs = [ "bin" "dev" "out" ];

  propagatedBuildInputs = [ libtiff libjpeg zlib ];

  meta = with stdenv.lib; {
    description = "Color management engine";
    homepage = "http://www.littlecms.com/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
