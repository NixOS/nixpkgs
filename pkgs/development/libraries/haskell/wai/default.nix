{ cabal, blazeBuilder, conduit, httpTypes, network, text
, transformers, vault
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "2.0.0";
  sha256 = "11s60v9pw8jl9w950z81gkxci7djrdibi8hxrw6j1v8az40qqiwk";
  buildDepends = [
    blazeBuilder conduit httpTypes network text transformers vault
  ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Web Application Interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
