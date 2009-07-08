{cabal, pcreLight, hscolour}:

cabal.mkDerivation (self : {
  pname = "ghc-core";
  version = "0.4.3";
  sha256 = "cdd6082ebc692087db781cb10194bbbf34a768b31eea0dcb78c73921c7047444";
  propagatedBuildInputs = [pcreLight hscolour];
  configureFlags = ''--constraint=base<4'';
  meta = {
    description = "Display GHC's core and assembly output in a pager";
  };
})  

