{ cabal, Cabal, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-algorithms";
  version = "2.2.0.1";
  sha256 = "1ggxa2h2swgf7621nrzlqmmyi3h2v526w69zcwvms84kyd257p4p";
  buildDepends = [ Cabal repa vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Algorithms using the Repa array library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
