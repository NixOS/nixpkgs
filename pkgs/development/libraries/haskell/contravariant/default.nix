{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "contravariant";
  version = "0.2.0.2";
  sha256 = "0142s1c914zbfnvysvcc9s3bv8qs6wimnqcmxca1gxaxqvyfkf3p";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/ekmett/contravariant/";
    description = "Haskell 98 contravariant functors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
