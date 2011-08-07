{cabal, text} :

cabal.mkDerivation (self : {
  pname = "xml-types";
  version = "0.3";
  sha256 = "0d0x7s865ca7bscskp6s7zyzpzd22nkd61wzwg11v6h0q5dilly7";
  propagatedBuildInputs = [ text ];
  meta = {
    description = "Basic types for representing XML";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
