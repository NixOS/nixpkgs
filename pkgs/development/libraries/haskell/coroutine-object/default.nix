{ cabal, cereal, either, lens, mtl, safecopy, transformers
, transformersFree, uuid
}:

cabal.mkDerivation (self: {
  pname = "coroutine-object";
  version = "0.2.0.0";
  sha256 = "1jl5glnk4ildjrxyxscxd0v7xfqbd9vpv5gaxygsfsbfr1zizp3s";
  buildDepends = [
    cereal either lens mtl safecopy transformers transformersFree uuid
  ];
  jailbreak = true;
  meta = {
    description = "Object-oriented programming realization using coroutine";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
