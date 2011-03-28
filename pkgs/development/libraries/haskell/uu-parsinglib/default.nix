{cabal, ListLike}:

cabal.mkDerivation (self : {
  pname = "uu-parsinglib";
  version = "2.7.0.1";
  sha256 = "0x5gggwy3r1v0z5n6jn699bcrb9r9s2gbll5ca6m9hdfxjr3x7k6";
  propagatedBuildInputs = [ListLike];
  meta = {
    description = "New version of the Utrecht University parser combinator library";
  };
})

