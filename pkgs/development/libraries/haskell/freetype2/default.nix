{ cabal }:

cabal.mkDerivation (self: {
  pname = "freetype2";
  version = "0.1.1";
  sha256 = "16ayyqvbl278z68ssfbv2nvbyxs7585zmnk2w53vlxvj0k9zj66s";
  isLibrary = true;
  isExecutable = true;
  meta = {
    description = "Haskell binding for FreeType 2 library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
