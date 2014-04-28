{ cabal, attoparsec, blazeBuilder, conduit, exceptions, filepath
, hspec, monadControl, network, primitive, resourcet
, streamingCommons, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit-extra";
  version = "1.1.0.2";
  sha256 = "0n2k1cz04wkhw7l6qh1zm5dmarml9bbyf8zl6430j0mw5i4hwxr2";
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
