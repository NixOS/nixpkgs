{ stdenv, fetchurl, pkgconfig }:

let baseurl = "http://perso.b2b2c.ca/sarrazip/dev"; in

stdenv.mkDerivation rec {
  name = "boolstuff-0.1.15";

  src = fetchurl {
    url = "${baseurl}/${name}.tar.gz";
    sha256 = "1mzw4368hqw0b6xr01yqcbs9jk9ma3qq9hk3iqxmkiwqqxgirgln";
  };

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Library for operations on boolean expression binary trees";
    homepage = "${baseurl}/boolstuff.html";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
