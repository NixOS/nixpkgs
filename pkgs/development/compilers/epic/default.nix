{ cabal, boehmgc, gmp, happy, mtl }:

cabal.mkDerivation (self: {
  pname = "epic";
  version = "0.1.13";
  sha256 = "00rdprgndrvssrjlp6jh5jak2rxq6bcd2dknldx6i8h1cq6i69rb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl ];
  buildTools = [ happy ];
  extraLibraries = [ boehmgc gmp ];
  meta = {
    homepage = "http://www.dcs.st-and.ac.uk/~eb/epic.php";
    description = "Compiler for a simple functional language";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
