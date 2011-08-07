{cabal, parsec, syb, xml} :

cabal.mkDerivation (self : {
  pname = "texmath";
  version = "0.4";
  sha256 = "1rvnhqljxkljy8ncpaj8p7b14nvvm6zmiixv13m1zxlcr457j2ai";
  propagatedBuildInputs = [ parsec syb xml ];
  meta = {
    homepage = "http://github.com/jgm/texmath";
    description = "Conversion of LaTeX math formulas to MathML.";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
