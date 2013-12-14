{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "enummapset-th";
  version = "0.6.0.0";
  sha256 = "0d5pb49raxamz6g9w5kgm4papv3wj21xd8zysfvfn19jkwhkd6mn";
  buildDepends = [ deepseq ];
  meta = {
    homepage = "https://github.com/liyang/enummapset-th";
    description = "TH-generated EnumSet/EnumMap wrappers around IntSet/IntMap";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
