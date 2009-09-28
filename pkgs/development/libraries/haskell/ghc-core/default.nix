{cabal, pcreLight, colorizeHaskell}:

cabal.mkDerivation (self : {
  pname = "ghc-core";
  version = "0.5";
  sha256 = "9880ea553a24a1ad6585c4d69505a3b1ac90aaf0f48ca8c126f41e8f170651ef";
  propagatedBuildInputs = [pcreLight colorizeHaskell];
  configureFlags = ''--constraint=base<4'';
  meta = {
    description = "Display GHC's core and assembly output in a pager";
  };
})  

