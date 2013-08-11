{ cabal, alex, filepath, happy, syb }:

cabal.mkDerivation (self: {
  pname = "language-c";
  version = "0.4.2";
  sha256 = "07pf4v4n7kvr5inkhs24b7g55pmkk4k5ihi6s5dbc200l01wz133";
  buildDepends = [ filepath syb ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://www.sivity.net/projects/language.c/";
    description = "Analysis and generation of C code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
