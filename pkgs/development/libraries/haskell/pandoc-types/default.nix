{cabal, syb} :

cabal.mkDerivation (self : {
  pname = "pandoc-types";
  version = "1.8.2";
  sha256 = "04whkqld2pnfz25i9rcq7d4pi9zkn6c1rpz95vdlg9r5xkhhnn3a";
  propagatedBuildInputs = [ syb ];
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Types for representing a structured document";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
