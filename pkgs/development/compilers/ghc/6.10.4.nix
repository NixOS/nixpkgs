{stdenv, fetchurl, libedit, ghc, perl, gmp, ncurses}:

stdenv.mkDerivation rec {
  version = "6.10.4";

  name = "ghc-${version}";

  src = fetchurl {
    url = "${meta.homepage}/dist/${version}/${name}-src.tar.bz2";
    sha256 = "d66a8e52572f4ff819fe5c4e34c6dd1e84a7763e25c3fadcc222453c0bd8534d";
  };

  buildInputs = [ghc libedit perl gmp];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-gmp-libraries=${gmp.out}/lib"
    "--with-gmp-includes=${gmp.dev}/include"
    "--with-gcc=${stdenv.cc}/bin/gcc"
  ];

  NIX_CFLAGS_COMPILE = "-fomit-frame-pointer";

  meta = {
    homepage = http://haskell.org/ghc;
    description = "The Glasgow Haskell Compiler";
    platforms = ["x86_64-linux" "i686-linux"];  # Darwin is unsupported.
    inherit (ghc.meta) license;
    broken = true;  # https://nix-cache.s3.amazonaws.com/log/6ys7lzckf2c0532kzhmss73mmz504can-ghc-6.10.4.drv
  };
}
