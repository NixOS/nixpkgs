{ cabal, blazeBuilder, filepath, HUnit, ieee754, mtl, syb, text
, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hastache";
  version = "0.5.1";
  sha256 = "05lm7mjzc1hamxcj8akq06081bhp907hrjdkhas3wzm6ran6rwn3";
  buildDepends = [
    blazeBuilder filepath ieee754 mtl syb text transformers utf8String
  ];
  testDepends = [ HUnit mtl syb text ];
  meta = {
    homepage = "http://github.com/lymar/hastache";
    description = "Haskell implementation of Mustache templates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
