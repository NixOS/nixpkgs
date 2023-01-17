{ lib, stdenv, fetchurl, libiconv }:

stdenv.mkDerivation rec {
  pname = "libcddb";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/libcddb/${pname}-${version}.tar.bz2";
    sha256 = "0fr21a7vprdyy1bq6s99m0x420c9jm5fipsd63pqv8qyfkhhxkim";
  };

  buildInputs = [ libiconv ];

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  doCheck = false; # fails 3 of 5 tests with locale errors

  meta = with lib; {
    description = "C library to access data on a CDDB server (freedb.org)";
    homepage = "http://libcddb.sourceforge.net/";
    license = licenses.lgpl2Plus;
    mainProgram = "cddb_query";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
