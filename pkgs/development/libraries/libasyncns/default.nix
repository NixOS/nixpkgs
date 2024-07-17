{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libasyncns";
  version = "0.8";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libasyncns/${pname}-${version}.tar.gz";
    sha256 = "0x5b6lcic4cd7q0bx00x93kvpyzl7n2abbgvqbrlzrfb8vknc6jg";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace libasyncns/asyncns.c \
      --replace '<arpa/nameser.h>' '<arpa/nameser_compat.h>'
  '';

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = with lib; {
    homepage = "http://0pointer.de/lennart/projects/libasyncns/";
    description = "A C library for Linux/Unix for executing name service queries asynchronously";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
