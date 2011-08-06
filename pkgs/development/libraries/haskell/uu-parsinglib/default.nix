{cabal, ListLike} :

cabal.mkDerivation (self : {
  pname = "uu-parsinglib";
  version = "2.7.1.1";
  sha256 = "1qn3impl64cvbzyvhc73yxyibgak4dkgl1vkbrzxrxb770kb5r4p";
  propagatedBuildInputs = [ ListLike ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/bin/view/HUT/ParserCombinators";
    description = "Fast, online, error-correcting, monadic, applicative, merging, permuting, idiomatic parser combinators.";
    license = self.stdenv.lib.licenses.mit;
  };
})
