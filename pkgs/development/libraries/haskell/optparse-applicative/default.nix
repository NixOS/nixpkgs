{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.4.2";
  sha256 = "0hxl4hhh24hz1fc23mbsx83ccnv2fkxbar37d9c5cmiaalsrfb19";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/pcapriotti/optparse-applicative";
    description = "Utilities and combinators for parsing command line options";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
