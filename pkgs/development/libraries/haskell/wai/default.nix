{ cabal, blazeBuilder, conduit, httpTypes, network, text
, transformers, vault
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "1.4.0";
  sha256 = "1213sib2qp1xafrrnmkxabgkba0g00awy6dx9jnlfkj5r6m32wdq";
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
