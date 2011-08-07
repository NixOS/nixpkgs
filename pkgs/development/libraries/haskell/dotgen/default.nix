{cabal} :

cabal.mkDerivation (self : {
  pname = "dotgen";
  version = "0.4.1";
  sha256 = "1g5ds0mqkz0lzhcp42hin08azschs3p083ikdk4d5jil8rzl7d8k";
  meta = {
    description = "A simple interface for building .dot graph files.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
