{ stdenv, fetchurl, libunwind }:

stdenv.mkDerivation rec {
  name = "gperftools-2.1";

  src = fetchurl {
    url = "https://gperftools.googlecode.com/files/${name}.tar.gz";
    sha256 = "0ks9gsnhxrs2vccc6ha9m8xmj83lmw09xcws4zc0k57q4jcy5bgk";
  };

  buildInputs = stdenv.lib.optional stdenv.isLinux libunwind;

  # some packages want to link to the static tcmalloc_minimal
  # to drop the runtime dependency on gperftools
  dontDisableStatic = true;

  enableParallelBuilding = true;

  meta = {
    homepage = https://code.google.com/p/gperftools/;
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
