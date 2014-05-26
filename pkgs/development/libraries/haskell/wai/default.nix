{ cabal, blazeBuilder, conduit, conduitExtra, httpTypes, network
, text, transformers, vault
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "2.1.0.3";
  sha256 = "0qprvk63fvb4rddg9h385xbd5sr5bcgkpx6fqlw01pjzmmrig1m3";
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
