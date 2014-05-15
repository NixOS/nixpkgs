{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "data-lens-light";
  version = "0.1.1";
  sha256 = "03nsfwpcl7wmw2bgcb8z3w04krlbrbks7bjpnzfdz6cgdr5mnjrs";
  buildDepends = [ mtl ];
  meta = {
    homepage = "https://github.com/feuerbach/data-lens-light";
    description = "Simple lenses, minimum dependencies";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
