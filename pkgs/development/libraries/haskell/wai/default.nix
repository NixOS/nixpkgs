{ cabal, blazeBuilder, conduit, conduitExtra, httpTypes, network
, text, transformers, vault
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "2.1.0.2";
  sha256 = "02hj07s3vlhbd2hds5pyksghildadjqhr8mmiyabwb7ap8iybidg";
  buildDepends = [
    blazeBuilder conduit conduitExtra httpTypes network text
    transformers vault
  ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Web Application Interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
