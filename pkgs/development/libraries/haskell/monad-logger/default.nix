{ cabal, fastLogger, resourcet, text, transformers }:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.2.0";
  sha256 = "0rsp24lx9gcvayj5d6afq26qrggm9qrjqjpdm7088xbl5k0c71fz";
  buildDepends = [ fastLogger resourcet text transformers ];
  meta = {
    homepage = "https://github.com/kazu-yamamoto/logger";
    description = "A class of monads which can log messages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
