{cabal, deepseq}:

cabal.mkDerivation (self : {
  pname = "text";
  version = "0.11.1.3"; # for ghc-7.2.1
  sha256 = "1r00azswhb71fi4w3191krs8ajjfbfxivjwx03i0y0rr99bgb9vg";
  propagatedBuildInputs = [deepseq];
  meta = {
    description = "An efficient package Unicode text type";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

