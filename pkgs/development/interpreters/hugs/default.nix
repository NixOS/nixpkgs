{ stdenv, lib, fetchurl, fetchpatch, bison, gcc }:

stdenv.mkDerivation {

  name = "hugs98-200609";

  src = fetchurl {
    url = "http://cvs.haskell.org/Hugs/downloads/2006-09/hugs98-Sep2006.tar.gz";
    sha256 = "1dj65c39zpy6qqvvrwns2hzj6ipnd4ih655xj7kgyk2nfdvd5x1w";
  };

  patches =
    [ (fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/hsbase_inline.patch?h=hugs";
      name = "hsbase_inline.patch";
      sha256 = "1h0sp16d17hlm6gj7zdbgwrjwi2l4q02m8p0wd60dp4gn9i9js0v";
    }) ] ++ lib.optionals stdenv.isDarwin [
      (fetchpatch {
        url = "https://github.com/FranklinChen/hugs98-plus-Sep2006/commit/f1294cc412caf495bf38c9f7ffc84a57f0650855.patch";
        sha256 = "0c9h8vbjk9bkmrxaz0lfg2fmxiixlm00ywybgamj6x1npyg4kqf5";
      })
      (fetchpatch {
        url = "https://github.com/FranklinChen/hugs98-plus-Sep2006/commit/b47454720f6a7fa3b63ca3cb9093ee395f1c4fb4.patch";
        sha256 = "05bs7b610nbmszy4lpscmwwz65640jrzybbr1mdm49rcflnd099z";
      })
      (fetchpatch {
        url = "https://github.com/FranklinChen/hugs98-plus-Sep2006/commit/8ed41c5f9d086c0bf53637df011a4504ee168ca1.patch";
        sha256 = "1ni7ab91vlznrkxp4mwln0affh3q5nw3jn6102hn35hjdb2a2xvk";
      })
      (fetchpatch {
        url = "https://github.com/FranklinChen/hugs98-plus-Sep2006/commit/5c4a0d18f2a941839947fc0c2126374e95164802.patch";
        sha256 = "190siizla95famlp80rsqhmyqy5al9mz6qg5zix04hqxkv3c6wr2";
      })
      (fetchpatch {
        url = "https://github.com/FranklinChen/hugs98-plus-Sep2006/commit/4f323b9ab1fd6c53fe48d72aad4e7fba2ce8850c.patch";
        sha256 = "1azzylllbbwvfrdfljk9wvkj8gcqxj3nmxya65xbffkrw1gp3kh2";
      })
    ];

  buildInputs = [ gcc ];

  nativeBuildInputs = [ bison ];

  postUnpack = "find -type f -exec sed -i 's@/bin/cp@cp@' {} +";

  preConfigure = "unset STRIP";

  enableParallelBuilding = true;

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

  meta = with stdenv.lib; {
    homepage = "https://www.haskell.org/hugs";
    description = "Haskell interpreter";
    maintainers = with maintainers; [ joachifm ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
