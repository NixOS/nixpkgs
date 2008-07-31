{stdenv, fetchurl, readline, ghc, happy, alex, perl, m4, gmp, ncurses, haskellEditline}:

stdenv.mkDerivation (rec {
  name = "ghc-6.9.20080719";
  homepage = "http://www.haskell.org/ghc";

  src = map fetchurl [
    { url    = "${homepage}/dist/current/dist/${name}-src.tar.bz2";
      sha256 = "ed2371c3632962fccab6ec60c04e9fc6a38f3ade3a30a464cea5d53784bc3a34";
    }
    { url    = "${homepage}/dist/current/dist/${name}-src-extralibs.tar.bz2";
      sha256 = "d3c7aa7d53befe268f92148cc8f3b0861dfdc84e9b21b039af0f5b230bfbf72b";
    }
  ];

  buildInputs = [ghc readline perl m4 gmp happy alex haskellEditline];

  # The setup hook is executed by other packages building with ghc.
  # It then looks for package configurations that are available and
  # build a package database on the fly.
  setupHook = ./setup-hook.sh;

  meta = {
    description = "The Glasgow Haskell Compiler";
  };

  configureFlags=[
    "--with-gmp-libraries=${gmp}/lib"
    "--with-gmp-includes=${gmp}/include"
    "--with-readline-libraries=${readline}/lib"
    "--with-gcc=${gcc}/bin/gcc"
  ];

  preConfigure = ''
    # should not be present in a clean distribution
    rm utils/pwd/pwd
    # fix bug in makefile
    sed -i -e 's/:\\"//' -e 's/\\"//' mk/config.mk.in
  '';

  postInstall = ''
    ln -s $out/lib/${name}/ghc $out/lib/${name}/${name}
  '';

  inherit (stdenv) gcc;
  inherit readline gmp ncurses;
})
