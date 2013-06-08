{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "temporary";
  version = "1.1.2.4";
  sha256 = "1j8kc22rz2wqg90n5wcxb06ylqv3lnz764077kvwhrw7mhmbp7jz";
  buildDepends = [ filepath ];
  meta = {
    homepage = "http://www.github.com/batterseapower/temporary";
    description = "Portable temporary file and directory support for Windows and Unix, based on code from Cabal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
