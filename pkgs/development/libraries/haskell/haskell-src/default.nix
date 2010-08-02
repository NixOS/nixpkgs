{cabal, happy}:

cabal.mkDerivation (self : {
  pname = "haskell-src";
  version = "1.0.1.3"; # Haskell Platform 2009.0.0 and 2010.1.0.0 and 2010.2.0.0
  sha256 = "a7872900acd2293775a6bdc6dc8f70438ccd80e62d2d1e2394ddff15b1883e89";
  extraBuildInputs = [happy];
  meta = {
    description = "Manipulating Haskell source code";
  };
})  

