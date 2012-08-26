{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "process-extras";
  version = "0.1.3";
  sha256 = "16hm1w34qnrpb6x8gaqv1bs1cd4p98kayf23275s6vd48kw9v0b0";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/davidlazar/process-extras";
    description = "Process extras";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
