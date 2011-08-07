{cabal} :

cabal.mkDerivation (self : {
  pname = "ObjectName";
  version = "1.0.0.0";
  sha256 = "0yr1aa0ail2h9qsq2bslcwwq6cxl2lzajmc1laj19r7ks62p32rm";
  meta = {
    homepage = "http://www.haskell.org/HOpenGL/";
    description = "Explicitly handled object names";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
