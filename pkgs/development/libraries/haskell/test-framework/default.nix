{cabal, ansiTerminal, ansiWlPprint, hostname, regexPosix, xml} :

cabal.mkDerivation (self : {
  pname = "test-framework";
  version = "0.4.1.1";
  sha256 = "1ig4v2y8xba2rg6pc8yjf0j20cwa3czknnfqn1sgpqhmip2961pc";
  propagatedBuildInputs = [
    ansiTerminal ansiWlPprint hostname regexPosix xml
  ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "Framework for running and organising tests, with HUnit and QuickCheck support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
