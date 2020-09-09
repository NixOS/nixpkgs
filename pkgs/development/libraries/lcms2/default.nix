{ stdenv, fetchurl, libtiff, libjpeg, zlib }:

stdenv.mkDerivation rec {
  name = "lcms2-2.11";

  src = fetchurl {
    url = "mirror://sourceforge/lcms/${name}.tar.gz";
    sha256 = "0bkpf315925lhmd9i4mzjnkq5dh255r1lms0c0vzzkfpwk4bjjfw";
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
