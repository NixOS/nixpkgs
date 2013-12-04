{ cabal }:

cabal.mkDerivation (self: {
  pname = "indexed";
  version = "0.1";
  sha256 = "1dx5pyi5psjd2l26hc3wfsapnywdl0kqpw98b3jwc0xq4406ax12";
  meta = {
    homepage = "https://github.com/reinerp/indexed";
    description = "Haskell98 indexed functors, monads, comonads";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
