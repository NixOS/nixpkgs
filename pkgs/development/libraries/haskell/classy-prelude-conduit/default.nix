{ cabal, classyPrelude, conduit, conduitCombinators, hspec
, monadControl, QuickCheck, resourcet, systemFileio, transformers
, void
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.8.1";
  sha256 = "16wiii630ivcsxrjkmks995lcn0q0plmzbg4h08g5mdgscql2ax1";
  buildDepends = [
    classyPrelude conduit conduitCombinators monadControl resourcet
    systemFileio transformers void
  ];
  testDepends = [ conduit hspec QuickCheck transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "conduit instances for classy-prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
