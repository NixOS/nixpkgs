{ cabal, blazeBuilder, Cabal, filepath, ieee754, mtl, syb, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hastache";
  version = "0.3.3";
  sha256 = "18ayrfwi3jn3q650m5dm9wx9c7djwc2miz3mxlscd9gzlnrfi772";
  buildDepends = [
    blazeBuilder Cabal filepath ieee754 mtl syb text utf8String
  ];
  meta = {
    homepage = "http://github.com/lymar/hastache";
    description = "Haskell implementation of Mustache templates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
