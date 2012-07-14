{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "text";
  version = "0.11.2.2";
  sha256 = "0ch0fiwjwkpiwamfxxbcka2gp6lbwpqcv7pmik6qm850163f4i33";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/bos/text";
    description = "An efficient packed Unicode text type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
