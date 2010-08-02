{ composableDerivation, fetchurl }:

let edf = composableDerivation.edf;
    wwf = composableDerivation.wwf; in
    
composableDerivation.composableDerivation {} {
  name = "hugs98";

  src = fetchurl {
    url = http://cvs.haskell.org/Hugs/downloads/2006-09/hugs98-Sep2006.tar.gz;
    sha256 = "3cf4d27673564cffe691bd14032369f646233f14daf2bc37c6c6df9f062b46b6";
  };

  #encode all character I/O using the byte encoding
  #determined by the locale in effect at that time. To
  #require that the UTF-8 encoding is always used, give
  #the --enable-char-encoding=utf8 option.
  #[default=autodetect]
  postUnpack = ''
    find -type f | xargs sed -i 's@/bin/cp@cp@';
  '';
  
  configurePhase = "./configure --prefix=\$out --enable-char-encoding=utf8 $configureFlags";

  flags =
       edf { name = "pathCanonicalization"; feat="path-canonicalization"; }
    // edf { name="timer"; }   # enable evaluation timing (for benchmarking Hugs)
    // edf { name="profiling"; }# enable heap profiler
    // edf { name="stackDumps"; feat="stack-dummps"; } # enable stack dump on stack overflow
    // edf { name="largeBanner"; feat="large-banner"; } # disable multiline startup banner
    // edf { name="internal-prims"; } # experimental primitives to access Hugs's innards
    // edf { name="debug"; } # include C debugging information (for debugging Hugs)
    // edf { name="tag"; } # runtime tag checking (for debugging Hugs)
    // edf { name="lint"; } # enable "lint" flags (for debugging Hugs)
    // edf { name="only98"; } # build Hugs to understand Haskell 98 only
    // edf { name="ffi"; }
      #--with-nmake            produce a Makefile compatible with nmake
      #--with-gui              build Hugs for Windows GUI (Borland C++ only)
    // wwf { name="pthreads"; } #   build Hugs using POSIX threads C library
    ;

  cfg = {
    largeBannerSupport = true; # seems to be default
    char = { cfgOption = "--enable-char-encoding"; blocks = "utf8"; };
    utf8 = { cfgOption = "--enable-char-encoding=utf8"; blocks="char"; };
  };

  meta = {
    license = "as-is"; # gentoo is calling it this way..
    description = "The HUGS 98 Haskell interpreter";
    homepage = http://www.haskell.org/hugs;
  };
}
