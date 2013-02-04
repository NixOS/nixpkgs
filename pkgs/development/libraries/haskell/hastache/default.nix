{ cabal, blazeBuilder, filepath, ieee754, mtl, syb, text
, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hastache";
  version = "0.5.0";
  sha256 = "1c1pphw7qx5l5fdfqchihvp2yrwwb0ln8dfshkvd1giv8cjmbyn8";
  buildDepends = [
    blazeBuilder filepath ieee754 mtl syb text transformers utf8String
  ];
  meta = {
    homepage = "http://github.com/lymar/hastache";
    description = "Haskell implementation of Mustache templates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
