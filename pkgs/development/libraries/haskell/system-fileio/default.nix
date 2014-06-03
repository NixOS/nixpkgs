{ cabal, chell, systemFilepath, temporary, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "system-fileio";
  version = "0.3.14";
  sha256 = "1x5cricx2n1wwvdad4i3q8s3gb28a129v3kkj9rn9803xh43zh29";
  buildDepends = [ systemFilepath text time ];
  testDepends = [
    chell systemFilepath temporary text time transformers
  ];
  meta = {
    homepage = "https://john-millikin.com/software/haskell-filesystem/";
    description = "Consistent filesystem interaction across GHC versions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
