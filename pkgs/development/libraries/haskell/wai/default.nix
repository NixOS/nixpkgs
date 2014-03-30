{ cabal, blazeBuilder, conduit, conduitExtra, httpTypes, network
, text, transformers, vault
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "2.1.0.1";
  sha256 = "03gp3ijdpyyh7zic89laj0y4wsi8f49lbqlqq8w9msfgizjhvdv6";
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
