{ cabal, ansiTerminal, split, text }:

cabal.mkDerivation (self: {
  pname = "mpppc";
  version = "0.1.3";
  sha256 = "1zcilskpslpqyrbwpabwbry4p3kpcfca94wchh9dkq9g8pg8laxi";
  buildDepends = [ ansiTerminal split text ];
  jailbreak = true;
  meta = {
    description = "Multi-dimensional parametric pretty-printer with color";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
