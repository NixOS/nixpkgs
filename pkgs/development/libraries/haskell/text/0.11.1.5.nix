{cabal, deepseq}:

cabal.mkDerivation (self : {
  pname = "text";
  version = "0.11.1.5"; # for ghc-7.2.1
  sha256 = "0fxxhw932gdvaqafsbw7dfzccc43hv92yhxppzp6jrg0npbyz04l";
  propagatedBuildInputs = [deepseq];
  meta = {
    description = "An efficient package Unicode text type";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

