{ cabal, attoparsec, blazeBuilder, conduit, exceptions, filepath
, hspec, monadControl, network, primitive, resourcet
, streamingCommons, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "conduit-extra";
  version = "1.1.1";
  sha256 = "1876kg7zb0gasl7ijmx48r5r2jv3c5xxa1xb6g6iqfysx0qsv6z2";
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
