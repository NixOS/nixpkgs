{ cabal, Cabal, deepseq, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "IntervalMap";
  version = "0.3.0.2";
  sha256 = "14pbq5n2cn9gxjkmqpnbn7dx9963wp3sdbb180wm9l5xqi338s0l";
  buildDepends = [ deepseq ];
  testDepends = [ Cabal deepseq QuickCheck ];
  meta = {
    homepage = "http://www.chr-breitkopf.de/comp/IntervalMap";
    description = "Maps from Intervals to values, with efficient search";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
