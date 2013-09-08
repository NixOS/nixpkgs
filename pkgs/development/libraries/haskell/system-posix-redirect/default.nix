{ cabal }:

cabal.mkDerivation (self: {
  pname = "system-posix-redirect";
  version = "1.1";
  sha256 = "08l8n671ypmharmkm9s8wv5ipcznn7hv5zadf96liml3v16d8fcr";
  meta = {
    description = "A toy module that allows you to temporarily redirect a program's stdout";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
