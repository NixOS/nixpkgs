{ cabal, attoparsec, blazeBuilder, blazeBuilderConduit, conduit
, text
}:

cabal.mkDerivation (self: {
  pname = "tagstream-conduit";
  version = "0.5.3";
  sha256 = "08g34dbb59mrpj0lym5a0zlygvj7in57nkhbk84kxvggrhl0jndl";
  buildDepends = [
    attoparsec blazeBuilder blazeBuilderConduit conduit text
  ];
  meta = {
    homepage = "http://github.com/yihuang/tagstream-conduit";
    description = "streamlined html tag parser";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
