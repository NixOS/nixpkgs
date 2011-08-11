{ cabal, blazeBuilder, enumerator, transformers }:

cabal.mkDerivation (self: {
  pname = "blaze-builder-enumerator";
  version = "0.2.0.2";
  sha256 = "0as4mjh695jpxp9qfhpsxyr1448l0pk94sh5kk8sgxv5hfiy41k9";
  buildDepends = [ blazeBuilder enumerator transformers ];
  meta = {
    homepage = "https://github.com/meiersi/blaze-builder-enumerator";
    description = "Enumeratees for the incremental conversion of builders to bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
