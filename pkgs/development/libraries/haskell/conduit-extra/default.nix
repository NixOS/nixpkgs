{ cabal, attoparsec, blazeBuilder, conduit, exceptions, filepath
, hspec, monadControl, network, primitive, resourcet
, streamingCommons, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit-extra";
  version = "1.1.0.1";
  sha256 = "1j1arx07aynziyc9b4bjd7wyydvi1nicdrv86jhyp1nd6zklj1m4";
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
