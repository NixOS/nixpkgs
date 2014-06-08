{ cabal, blazeBuilder, dataDefault, deepseq, text, time }:

cabal.mkDerivation (self: {
  pname = "cookie";
  version = "0.4.1.1";
  sha256 = "1w1nh7h4kc9pr9kpi8fkrqiih37mp3gcnxf42r01nciq4sh4yi3m";
  buildDepends = [ blazeBuilder dataDefault deepseq text time ];
  meta = {
    homepage = "http://github.com/snoyberg/cookie";
    description = "HTTP cookie parsing and rendering";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
