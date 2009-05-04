{cabal, time, parsec, stm, libX11, mesa, wxGTK}:

cabal.mkDerivation (self : {
  pname = "wxcore";
  version = "0.11.1.2";
  sha256 = "b91b17243d8a08d96f572224c434c36d14feb1b0bb64a0e63900f0103a7c4752";
  propagatedBuildInputs = [time parsec stm libX11 wxGTK mesa];
  /* configureFlags = [ "--with-opengl" ]; */
  preConfigure = ''
    sed -i 's/ghc-pkg latest/ghc-pkg --global latest/g' configure
    sed -i 's/pkg describe/pkg --global describe/g' configure
  '';
  meta = {
    description = "wxHaskell core";
  };
})  

