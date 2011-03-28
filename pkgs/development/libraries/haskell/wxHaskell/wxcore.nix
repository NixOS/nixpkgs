{cabal, time, parsec, stm, wxdirect, libX11, mesa, wxGTK}:

cabal.mkDerivation (self : {
  pname = "wxcore";
  version = "0.12.1.6";
  sha256 = "162m7z8nzdwsszha87mvz7dzxh268n0sgymf3vq2yn5axw7zx5ap";
  propagatedBuildInputs = [time parsec stm libX11 wxGTK mesa wxdirect];
  preConfigure = ''
    sed -i 's|\(containers.*\) && < 0.4|\1|' ${self.pname}.cabal
  '';
  /* configureFlags = [ "--with-opengl" ]; */
  /*
  preConfigure = ''
    sed -i 's/ghc-pkg latest/ghc-pkg --global latest/g' configure
    sed -i 's/pkg describe/pkg --global describe/g' configure
  '';
  */
  meta = {
    description = "wxHaskell core";
  };
})

