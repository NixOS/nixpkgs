{ stdenv, fetchurl, pkgconfig }:

let baseurl = "http://perso.b2b2c.ca/sarrazip/dev"; in

stdenv.mkDerivation rec {
  name = "boolstuff-0.1.14";

  src = fetchurl {
    url = "${baseurl}/${name}.tar.gz";
    sha256 = "1ccn9v3kxz44pv3mr8q0l2i9769jiigw1gfv47ia50mbspwb87r6";
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
