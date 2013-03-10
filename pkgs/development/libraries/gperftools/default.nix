{ stdenv, fetchurl, libunwind }:

stdenv.mkDerivation rec {
  name = "gperftools-2.0";

  src = fetchurl {
    url = "https://gperftools.googlecode.com/files/${name}.tar.gz";
    sha1 = "da7181a7ba9b5ee7302daf6c16e886c179fe8d1b";
  };

  patches = [ ./glibc-2.16.patch ];

  buildInputs = [ libunwind ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://code.google.com/p/gperftools/;
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools";
    platforms = stdenv.lib.platforms.linux;
  };
}
