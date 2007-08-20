args: with args.lib; with args;
let
  co = chooseOptionsByFlags {
    inherit args;
    flagDescr = {
      # does without X make sense? We can try
      mandatory ={ cfgOption = [ "--prefix=\$out" ]; implies = "pthreads"; };
      pathcanonicalization = { cfgOption = "--enable-path-canonicalization"; }; # enable canonicalization of filenames
      timer = { cfgOption = "--enable-timer"; };#          enable evaluation timing (for benchmarking Hugs)
      profiling = { cfgOption = "--enable-profiling"; };#      enable heap profiler
      stack = { cfgOption = "--enable-stack-dumps"; };#-dumps    enable stack dump on stack overflow
      large = { cfgOption = "--disable-large-banner"; };#-banner  disable multiline startup banner
      internal = { cfgOption = "--enable-internal-prims"; };#-prims experimental primitives to access Hugs's innards
      debug = { cfgOption = "--enable-debug"; };#          include C debugging information (for debugging Hugs)
      tag = { cfgOption = "--enable-tag-checks"; };#-checks     runtime tag checking (for debugging Hugs)
      lint = { cfgOption = "--enable-lint"; };#           enable "lint" flags (for debugging Hugs)
      only98 = { cfgOption = "--enable-only98"; };#         build Hugs to understand Haskell 98 only
      ffi = { cfgOption = "--enable-ffi"; };#            include modules that use the FFI [default=autodetect]
      char = { cfgOption = "--enable-char-encoding"; blocks = "utf8"; };
                                                        #-encoding  encode all character I/O using the byte encoding
                                                        #determined by the locale in effect at that time. To
                                                        #require that the UTF-8 encoding is always used, give
                                                        #the --enable-char-encoding=utf8 option.
                                                        #[default=autodetect]
      utf8 = { cfgOption = "--enable-char-encoding=utf8"; blocks="char"; };


      #--with-nmake            produce a Makefile compatible with nmake
      #--with-gui              build Hugs for Windows GUI (Borland C++ only)
      pthreads = { cfgOption = "--with-pthreads"; }; #   build Hugs using POSIX threads C library
                                                   # I think we need this as long as not using nptl ?

    };
    optionals = [];
    defaultFlags = ["ffi"];
  };

in args.stdenv.mkDerivation {

  # passing the flags in case a library using this want's to check them (*) .. 
  inherit (co) /* flags */ buildInputs;

  configurePhase="./configure --prefix=\$out";

  src = fetchurl {
      url = http://cvs.haskell.org/Hugs/downloads/2006-09/hugs98-Sep2006.tar.gz;
      sha256 = "3cf4d27673564cffe691bd14032369f646233f14daf2bc37c6c6df9f062b46b6";
    };

  name="hugs98";

  meta = {
    license = "as-is"; # gentoo is calling it this way..
    description = "The HUGS98 Haskell <interpreter";
    homepage = http://www.haskell.org/hugs;
  };
}
