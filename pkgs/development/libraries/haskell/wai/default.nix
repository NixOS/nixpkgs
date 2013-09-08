{ cabal, blazeBuilder, conduit, httpTypes, network, text
, transformers, vault
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "1.4.0.2";
  sha256 = "0mmnl2zn3jsa5yan58kf2d7cvc343cld0l8mydb9qnq4if2kq94q";
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
