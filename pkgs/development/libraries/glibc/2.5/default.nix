{ stdenv, fetchurl, kernelHeaders
, installLocales ? true
, profilingLibraries ? false
}:

stdenv.mkDerivation {
  name = "glibc-2.5";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-2.5.tar.bz2;
    md5 = "1fb29764a6a650a4d5b409dda227ac9f";
  };

  patches = [ ./glibc-pwd.patch ./glibc-getcwd-param-MAX.patch ./glibc-inline.patch
              ./x86-fnstsw.patch ./binutils-ld.patch ./make-3-82-fix.patch ];

  inherit kernelHeaders installLocales;

  inherit (stdenv) is64bit;

  configureFlags="--enable-add-ons
    --with-headers=${kernelHeaders}/include
    --disable-sanity-checks
    ${if profilingLibraries then "--enable-profile" else "--disable-profile"}";

  # Workaround for this bug:
  #   http://sourceware.org/bugzilla/show_bug.cgi?id=411
  # I.e. when gcc is compiled with --with-arch=i686, then the
  # preprocessor symbol `__i686' will be defined to `1'.  This causes
  # the symbol __i686.get_pc_thunk.dx to be mangled.
  NIX_CFLAGS_COMPILE = "-U__i686";

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.gnu.org/software/libc/;
    description = "The GNU C Library";
  };
}
