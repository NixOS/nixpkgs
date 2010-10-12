{cabal, utf8String, terminfo, deepseq, mtl, parallel, parsec, vectorSpace}:

cabal.mkDerivation (self : {
  pname = "vty";
  version = "4.4.0.0";
  sha256 = "bf032022a72831e263d2d48d0a7a3191fb1174554cd714902a60cb0f39afe312";
  propagatedBuildInputs =
    [utf8String terminfo deepseq mtl parallel parsec vectorSpace];
  meta = {
    description = "A simple terminal access library";
  };
})
