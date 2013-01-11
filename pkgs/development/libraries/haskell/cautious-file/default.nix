{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "cautious-file";
  version = "1.0.2";
  sha256 = "1sw5ngwrarq1lsd4c6v2wdmgbhkkq6kpybb62r8ccm11ddgn3yiq";
  buildDepends = [ filepath ];
  meta = {
    description = "Ways to write a file cautiously, to reduce the chances of problems such as data loss due to crashes or power failures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
