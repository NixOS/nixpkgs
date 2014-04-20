{ cabal, async, dataDefault, filepath, leveldb, resourcet
, transformers
}:

cabal.mkDerivation (self: {
  pname = "leveldb-haskell";
  version = "0.3.0";
  sha256 = "0hdxn6v7fzc0wlpkymlci60m2584h6fn78bxdnv2q18ra03r3ygs";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    async dataDefault filepath resourcet transformers
  ];
  extraLibraries = [ leveldb ];
  meta = {
    homepage = "http://github.com/kim/leveldb-haskell";
    description = "Haskell bindings to LevelDB";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
