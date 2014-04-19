{ cabal, attoparsec, blazeBuilder, conduit, exceptions, filepath
, hspec, monadControl, network, primitive, resourcet
, streamingCommons, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit-extra";
  version = "1.1.0";
  sha256 = "08s8nafsdkd4dwmi2vsid82z8iv178vm9jbb322ygnbpf2a9y96y";
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
