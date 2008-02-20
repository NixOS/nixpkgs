{ stdenv, fetchurl, kernelHeaders
, installLocales ? true
, profilingLibraries ? false
}:

stdenv.mkDerivation {
  name = "glibc-2.7";
  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://gnu/glibc/glibc-2.7.tar.bz2;
    sha256 = "06j5q20l11x8kcrl9bg15xgb1pw0w82pazikxf4zvq2fmhiaa922";
  };

  inherit kernelHeaders installLocales;

  inherit (stdenv) is64bit;

  # `--with-tls --without-__thread' enables support for TLS but causes
  # it not to be used.  Required if we don't want to barf on 2.4
  # kernels.  Or something.
  configureFlags="--enable-add-ons
    --with-headers=${kernelHeaders}/include
    ${if profilingLibraries then "--enable-profile" else "--disable-profile"}";

  # Workaround for this bug:
  #   http://sourceware.org/bugzilla/show_bug.cgi?id=411
  # I.e. when gcc is compiled with --with-arch=i686, then the
  # preprocessor symbol `__i686' will be defined to `1'.  This causes
  # the symbol __i686.get_pc_thunk.dx to be mangled.
  NIX_CFLAGS_COMPILE = "-U__i686";
}
