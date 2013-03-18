{ cabal, cereal, conduit, transformers, HUnit }:

cabal.mkDerivation (self: {
  pname = "cereal-conduit";
  version = "0.7";
  sha256 = "0cf0lp47qiilrdrzmn58hwh3q7fh7g55f2a1r1bw31xapp1cvbix";
  buildDepends = [ cereal conduit transformers HUnit ];
  meta = {
    homepage = "https://github.com/litherum/cereal-conduit";
    description = "Turn Data.Serialize Gets and Puts into Sources, Sinks, and Conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
