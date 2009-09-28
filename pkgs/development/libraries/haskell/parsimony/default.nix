{cabal, utf8String}:

cabal.mkDerivation (self : {
  pname = "parsimony";
  version = "1";
  sha256 = "8196029dc346470301f4535f678724412060a0aafd81b017211b57635a25a378";
  propagatedBuildInputs = [utf8String];
  meta = {
    description = "Monadic parser combinators derived from Parsec";
  };
})  

