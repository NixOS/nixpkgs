{ lib, stdenv, fetchurl, bison }:

stdenv.mkDerivation rec {
  pname = "hugs98";
  version = "2006-09";

  src = fetchurl {
    url = "https://www.haskell.org/hugs/downloads/${version}/hugs98-Sep2006.tar.gz";
    sha256 = "1dj65c39zpy6qqvvrwns2hzj6ipnd4ih655xj7kgyk2nfdvd5x1w";
  };

  patches =
    [ (fetchurl {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/hsbase_inline.patch?h=hugs";
        name = "hsbase_inline.patch";
        sha256 = "1h0sp16d17hlm6gj7zdbgwrjwi2l4q02m8p0wd60dp4gn9i9js0v";
      })
    ];

  nativeBuildInputs = [ bison ];

  postUnpack = "find -type f -exec sed -i 's@/bin/cp@cp@' {} +";

  preConfigure = "unset STRIP";

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

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://www.haskell.org/hugs";
    description = "Haskell interpreter";
    maintainers = with maintainers; [ joachifm ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
