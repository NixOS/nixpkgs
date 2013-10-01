{ cabal }:

cabal.mkDerivation (self: {
  pname = "rfc5051";
  version = "0.1.0.3";
  sha256 = "0av4c3qvwbkbzrjrrg601ay9pds7wscqqp2lc2z78mv2lllap3g3";
  isLibrary = true;
  isExecutable = true;
  meta = {
    description = "Simple unicode collation as per RFC5051";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
