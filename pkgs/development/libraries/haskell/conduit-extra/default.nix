{ cabal, attoparsec, blazeBuilder, conduit, exceptions, filepath
, hspec, monadControl, network, primitive, resourcet
, streamingCommons, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit-extra";
  version = "1.1.0.3";
  sha256 = "117lirx05pgpmys6dlknkcni3znrvqyhmj6djqxnqbjcn3ynhqdk";
  buildDepends = [
    attoparsec blazeBuilder conduit filepath monadControl network
    primitive resourcet streamingCommons text transformers
    transformersBase
  ];
  testDepends = [
    attoparsec blazeBuilder conduit exceptions hspec resourcet text
    transformers transformersBase
  ];
  noHaddock = true;
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Batteries included conduit: adapters for common libraries";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
