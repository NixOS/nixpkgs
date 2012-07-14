{ cabal, blazeBuilder, filepath, ieee754, mtl, syb, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hastache";
  version = "0.4.1";
  sha256 = "1d6d3bmmfx1jh38hhmvaq1ncdxlfjc0mc7jvbxqgr00dg73wfgdk";
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
