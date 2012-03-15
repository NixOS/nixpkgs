{ cabal, happy, mtl, utf8Light }:

cabal.mkDerivation (self: {
  pname = "language-javascript";
  version = "0.4.10";
  sha256 = "1bk5xrhj5cpacz2bcfjz28sldizdadg05daalppxq8vs830sdx5h";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl utf8Light ];
  buildTools = [ happy ];
  meta = {
    homepage = "http://github.com/alanz/language-javascript";
    description = "Parser for JavaScript";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
