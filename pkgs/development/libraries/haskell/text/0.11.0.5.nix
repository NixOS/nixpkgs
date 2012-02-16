{ cabal, Cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "text";
  version = "0.11.0.5";
  sha256 = "1a5y2i7qrkyyvm112q44rhd7jbqxvfxssz2g5ngbx11yypl3hcdv";
  buildDepends = [ Cabal deepseq ];
  meta = {
    homepage = "http://bitbucket.org/bos/text";
    description = "An efficient packed Unicode text type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
