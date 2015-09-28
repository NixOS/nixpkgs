{ stdenv, fetchurl, bison }:

stdenv.mkDerivation {

  name = "hugs98-200609";

  src = fetchurl {
    url = http://cvs.haskell.org/Hugs/downloads/2006-09/hugs98-Sep2006.tar.gz;
    sha256 = "3cf4d27673564cffe691bd14032369f646233f14daf2bc37c6c6df9f062b46b6";
  };

  buildInputs = [ bison ];

  postUnpack = "find -type f -exec sed -i 's@/bin/cp@cp@' {} +";

  configureFlags = [
    "--enable-char-encoding=utf8"       # require that the UTF-8 encoding is always used
    "--disable-path-canonicalization"
    "--disable-timer"                   # evaluation timing (for benchmarking Hugs)
    "--disable-profiling"               # heap profiler
    "--disable-stack-dumps"             # stack dump on stack overflow
    "--enable-large-banner"             # multiline startup banner
    "--disable-internal-prims"          # experimental primitives to access Hugs's innards
    "--disable-debug"                   # include C debugging information (for debugging Hugs)
    "--disable-tag"                     # runtime tag checking (for debugging Hugs)
    "--disable-lint"                    # "lint" flags (for debugging Hugs)
    "--disable-only98"                  # build Hugs to understand Haskell 98 only
    "--enable-ffi"
    "--enable-pthreads"                 # build Hugs using POSIX threads C library
  ];

  meta = {
    homepage = http://www.haskell.org/hugs;
    description = "Haskell interpreter";
    license = "as-is";                          # gentoo labels it this way
    platforms = stdenv.lib.platforms.unix;      # arbitrary choice
  };
}
