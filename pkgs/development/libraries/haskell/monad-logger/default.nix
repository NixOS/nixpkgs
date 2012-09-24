{ cabal, fastLogger, resourcet, text, transformers }:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.2.1";
  sha256 = "00ssh60rxw7dg1dcfh8kr4mg9p7pvvvmjf9xd8kvxbrb9s3nkc4s";
  buildDepends = [ fastLogger resourcet text transformers ];
  meta = {
    homepage = "https://github.com/kazu-yamamoto/logger";
    description = "A class of monads which can log messages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
