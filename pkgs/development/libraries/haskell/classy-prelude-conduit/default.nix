{ cabal, classyPrelude, conduit, hspec, monadControl, QuickCheck
, resourcet, transformers, void, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude-conduit";
  version = "0.5.3";
  sha256 = "1rmx439kdjipyz2s3v2s1xv1mb55kb4njl9k6f8mfhykgac39rhz";
  buildDepends = [
    classyPrelude conduit monadControl resourcet transformers void
    xmlConduit
  ];
  testDepends = [ conduit hspec QuickCheck transformers ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "conduit instances for classy-prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
