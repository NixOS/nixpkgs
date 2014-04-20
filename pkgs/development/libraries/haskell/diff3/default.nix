{ cabal, Diff, QuickCheck, testFramework, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "diff3";
  version = "0.2.0.3";
  sha256 = "0zdfn1jhsq8pd23qpkhzr8wgiwbazfbq688bjnpc406i7gq88k78";
  buildDepends = [ Diff ];
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/ocharles/diff3.git";
    description = "Perform a 3-way difference of documents";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
