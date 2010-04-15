{cabal, deepseq}:

cabal.mkDerivation (self : {
  pname = "text";
  version = "0.7.1.0";
  sha256 = "a6daa0ee43ddede620363ab26614fef69361bd5b8f77aa6918b5a4ecb083f425";
  propagatedBuildInputs = [deepseq];
  meta = {
    description = "An efficient package Unicode text type";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

