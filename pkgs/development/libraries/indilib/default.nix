{ stdenv, fetchurl, cfitsio, libusb, zlib }:

stdenv.mkDerivation {
  name = "indilib-0.5";

  src = fetchurl {
    url = mirror://sf/indi/indilib-0.5.tar.gz;
    sha256 = "02km37m3d2l8c9wnab24zm2k6a3l8h2fali74jhm4z3khwr277ad";
  };

  propagatedBuildInputs = [ cfitsio libusb zlib ];

  meta = {
    homepage = http://indi.sf.net;
  };
}
