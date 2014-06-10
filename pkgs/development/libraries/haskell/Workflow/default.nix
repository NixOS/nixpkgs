{ cabal, binary, exceptions, extensibleExceptions, mtl
, RefSerialize, stm, TCache, vector
}:

cabal.mkDerivation (self: {
  pname = "Workflow";
  version = "0.8.1";
  sha256 = "0z23g68gcbbn43i78cql4is9js3m4z16rm2x8s57f73n0hx7f00l";
  buildDepends = [
    binary exceptions extensibleExceptions mtl RefSerialize stm TCache
    vector
  ];
  meta = {
    description = "Workflow patterns over a monad for thread state logging & recovery";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.tomberek ];
  };
})
