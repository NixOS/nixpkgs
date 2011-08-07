{cabal, utf8String, terminfo, deepseq, mtl, parallel, parsec, vectorSpace}:

cabal.mkDerivation (self : {
  pname = "vty";
  version = "4.6.0.4";
  sha256 = "0kabssw3v7nglvsr687ppmdnnmii1q2g5zg8rxwi2hcmvnjx7567";
  propagatedBuildInputs =
    [utf8String terminfo deepseq mtl parallel parsec vectorSpace];
  meta = {
    description = "A simple terminal access library";
  };
})
