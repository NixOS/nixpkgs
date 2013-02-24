{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "text";
  version = "0.11.1.5";
  sha256 = "0fxxhw932gdvaqafsbw7dfzccc43hv92yhxppzp6jrg0npbyz04l";
  buildDepends = [ deepseq ];
  doCheck = false;
  meta = {
    homepage = "https://bitbucket.org/bos/text";
    description = "An efficient packed Unicode text type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
