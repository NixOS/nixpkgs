{cabal, ListLike}:

cabal.mkDerivation (self : {
  pname = "uu-parsinglib";
  version = "2.7.1";
  sha256 = "10zpgpg93lp1jkrd77wkcdhf1a78hdzbvshq87q846nbv74f59cd";
  propagatedBuildInputs = [ListLike];
  meta = {
    description = "New version of the Utrecht University parser combinator library";
  };
})

