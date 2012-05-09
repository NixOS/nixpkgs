{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "abstract-par";
  version = "0.3.1";
  sha256 = "0qzv520823b07hrr49rnpzayh96m6cjrmb1cn9l0dn80j6k9xayk";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/simonmar/monad-par";
    description = "Type classes generalizing the functionality of the 'monad-par' library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
