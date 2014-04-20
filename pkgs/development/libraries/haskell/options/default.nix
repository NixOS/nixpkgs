{ cabal, chell, chellQuickcheck, monadsTf, transformers }:

cabal.mkDerivation (self: {
  pname = "options";
  version = "1.0";
  sha256 = "0d40d6k1c8v2b0bgchgl54sk9wx28kysp8bjws8bwjcmmd57775f";
  buildDepends = [ monadsTf transformers ];
  testDepends = [ chell chellQuickcheck monadsTf transformers ];
  doCheck = false;
  meta = {
    homepage = "https://john-millikin.com/software/haskell-options/";
    description = "A powerful and easy-to-use command-line option parser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
