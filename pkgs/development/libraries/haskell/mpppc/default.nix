{ cabal, ansiTerminal, Cabal, split, text }:

cabal.mkDerivation (self: {
  pname = "mpppc";
  version = "0.1.2";
  sha256 = "1zms71wx5a6rd60xy1pv6g1kxlx0hzh36pbr5a5lkfflc583z1k5";
  buildDepends = [ ansiTerminal Cabal split text ];
  meta = {
    description = "Multi-dimensional parametric pretty-printer with color";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
