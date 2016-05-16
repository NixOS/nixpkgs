{ stdenv, fetchurl, ghc, perl, gmp, ncurses, libiconv }:

stdenv.mkDerivation rec {
  version = "7.0.4";
  name = "ghc-${version}";

  src = fetchurl {
    url = "http://haskell.org/ghc/dist/${version}/${name}-src.tar.bz2";
    sha256 = "1a9b78d9d66c9c21de6c0932e36bb87406a4856f1611bf83bd44539bdc6ed0ed";
  };

  patches = [ ./fix-7.0.4-clang.patch ];

  buildInputs = [ ghc perl gmp ncurses ];

  buildMK = ''
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-libraries="${gmp.out}/lib"
    libraries/integer-gmp_CONFIGURE_OPTS += --configure-option=--with-gmp-includes="${gmp.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-includes="${ncurses.dev}/include"
    libraries/terminfo_CONFIGURE_OPTS += --configure-option=--with-curses-libraries="${ncurses.out}/lib"
    ${stdenv.lib.optionalString stdenv.isDarwin ''
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-includes="${libiconv}/include"
      libraries/base_CONFIGURE_OPTS += --configure-option=--with-iconv-libraries="${libiconv}/lib"
    ''}
  '';

  preConfigure = ''
    echo "${buildMK}" > mk/build.mk
    sed -i -e 's|-isysroot /Developer/SDKs/MacOSX10.5.sdk||' configure
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    find . -name '*.hs'  | xargs sed -i -e 's|ASSERT (|ASSERT(|' -e 's|ASSERT2 (|ASSERT2(|' -e 's|WARN (|WARN(|'
    find . -name '*.lhs' | xargs sed -i -e 's|ASSERT (|ASSERT(|' -e 's|ASSERT2 (|ASSERT2(|' -e 's|WARN (|WARN(|'
    export NIX_LDFLAGS+=" -no_dtrace_dof"
  '';

  configureFlags = if stdenv.isDarwin then "--with-gcc=${./gcc-clang-wrapper.sh}"
                                      else "--with-gcc=${stdenv.cc}/bin/gcc";

  NIX_CFLAGS_COMPILE = "-fomit-frame-pointer";

  # required, because otherwise all symbols from HSffi.o are stripped, and
  # that in turn causes GHCi to abort
  stripDebugFlags=["-S" "--keep-file-symbols"];

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    maintainers = [
      stdenv.lib.maintainers.marcweber
      stdenv.lib.maintainers.andres
      stdenv.lib.maintainers.peti
    ];
    platforms = ["x86_64-linux" "i686-linux"];  # Darwin is not supported.
    inherit (ghc.meta) license;
  };

}
