{ stdenv, fetchurl, pkgconfig }:

let baseurl = "http://perso.b2b2c.ca/sarrazip/dev"; in

stdenv.mkDerivation rec {
  name = "boolstuff-0.1.13";

  src = fetchurl {
    url = "${baseurl}/${name}.tar.gz";
    sha256 = "0akwb57lnzq1ak32k6mdxbma2gj0pqhj8y9m6hq79djb9s3mxvmn";
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
