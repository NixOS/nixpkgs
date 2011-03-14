{cabal, deepseq}:

cabal.mkDerivation (self : {
  pname = "text";
  version = "0.11.0.5"; # Haskell Platform 2011.2.0.0
  sha256 = "1a5y2i7qrkyyvm112q44rhd7jbqxvfxssz2g5ngbx11yypl3hcdv";
  propagatedBuildInputs = [deepseq];
  meta = {
    description = "An efficient package Unicode text type";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

