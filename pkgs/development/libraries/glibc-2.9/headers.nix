{ stdenv, fetchurl, kernelHeaders
, profilingLibraries ? false
}:

stdenv.mkDerivation rec {
  name = "glibc-headers-2.9";

  builder = ./headersbuilder.sh;

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-2.9.tar.bz2;
    sha256 = "0v53m7flx6qcx7cvrvvw6a4dx4x3y6k8nvpc4wfv5xaaqy2am2q9";
  };

  srcPorts = fetchurl {
    url = http://ftp.gnu.org/gnu/glibc/glibc-ports-2.9.tar.bz2;
    sha256 = "0r2sn527wxqifi63di7ns9wbjh1cainxn978w178khhy7yw9fk42";
  };

  inherit kernelHeaders;

  inherit (stdenv) is64bit;

  patches = [
    /* Support GNU Binutils 2.20 and above.  */
    ./binutils-2.20.patch
  ];

  configureFlags = [
    "--enable-add-ons"
    "--with-headers=${kernelHeaders}/include"
    "--disable-sanity-checks"
    "--enable-hacker-mode"
    (if profilingLibraries then "--enable-profile" else "--disable-profile")
  ] ++ (if (stdenv.system == "armv5tel-linux") then [
    "--host=arm-linux-gnueabi"
    "--build=arm-linux-gnueabi"
    "--without-fp"
  ] else []);

  buildPhase = "true";

  # I took some tricks from crosstool-0.43
  installPhase = ''
    make cross-compiling=yes CFLAGS=-DBOOTSTRAP_GCC install-headers
    mkdir -p $out/include/gnu
    touch $out/include/gnu/stubs.h
    cp ../include/features.h $out/include/features.h
    (cd $out/include && ln -s $kernelHeaders/include/* .) || exit 1
  '';

  # Workaround for this bug:
  #   http://sourceware.org/bugzilla/show_bug.cgi?id=411
  # I.e. when gcc is compiled with --with-arch=i686, then the
  # preprocessor symbol `__i686' will be defined to `1'.  This causes
  # the symbol __i686.get_pc_thunk.dx to be mangled.
  NIX_CFLAGS_COMPILE = "-U__i686";

  meta = {
    homepage = http://www.gnu.org/software/libc/;
    description = "The GNU C Library";
  };
}
