{ cabal, blazeBuilder, filepath, ieee754, mtl, syb, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hastache";
  version = "0.4.2";
  sha256 = "1ad691qxnnx0a6ik0cjdzd8aw7z88p06zckbb3cb1r8pk6m0g7vi";
  buildDepends = [
    blazeBuilder filepath ieee754 mtl syb text utf8String
  ];
  meta = {
    homepage = "http://github.com/lymar/hastache";
    description = "Haskell implementation of Mustache templates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
