{ cabal, liftedBase, monadControl, mtl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.4.0.1";
  sha256 = "0idyb2xvjk9cbz9gy1gr6sw1mz6v9d8fgk0kw778n6k3h488dw9x";
  buildDepends = [
    liftedBase monadControl mtl transformers transformersBase
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Deterministic allocation and freeing of scarce resources";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
