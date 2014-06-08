{ cabal, HUnit, parsec, prettyclass }:

cabal.mkDerivation (self: {
  pname = "language-glsl";
  version = "0.0.2";
  sha256 = "1ixgivyc5kqjg83rymrjs1mvypvqrczmj6dhn3dbw2a9lhrvljsz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ HUnit parsec prettyclass ];
  meta = {
    description = "GLSL abstract syntax tree, parser, and pretty-printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
