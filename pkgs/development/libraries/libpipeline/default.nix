{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libpipeline-1.5.3";

  src = fetchurl {
    url = "mirror://savannah/libpipeline/${name}.tar.gz";
    sha256 = "1c5dl017xil2ssb6a5vg927bnsbc9vymfgi9ahvqbb8gypx0igsx";
  };

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./fix-on-osx.patch ];

  meta = with stdenv.lib; {
    homepage = "http://libpipeline.nongnu.org";
    description = "C library for manipulating pipelines of subprocesses in a flexible and convenient way";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
