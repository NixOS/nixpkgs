{ stdenv, fetchurl, pkgconfig }:

let baseurl = "https://perso.b2b2c.ca/~sarrazip/dev"; in

stdenv.mkDerivation rec {
  name = "boolstuff-0.1.16";

  src = fetchurl {
    url = "${baseurl}/${name}.tar.gz";
    sha256 = "10qynbyw723gz2vrvn4xk2var172kvhlz3l3l80qbdsfb3d12wn0";
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
