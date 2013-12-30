{ cabal }:

cabal.mkDerivation (self: {
  pname = "system-posix-redirect";
  version = "1.1.0.1";
  sha256 = "1wkfz898d3607xnx779l1k1qc8i2k63ixg47542r45scwq8m0lsk";
  meta = {
    description = "A toy module to temporarily redirect a program's stdout";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
