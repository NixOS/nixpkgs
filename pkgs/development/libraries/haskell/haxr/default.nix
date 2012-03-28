{ cabal, blazeBuilder, dataenc, HaXml, HTTP, mtl, network, time
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haxr";
  version = "3000.8.5";
  sha256 = "1gfifqc7ldklapnymwd9ss0lll6q87sbg1hc6pa4c9sh275x1rz6";
  buildDepends = [
    blazeBuilder dataenc HaXml HTTP mtl network time utf8String
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/HaXR";
    description = "XML-RPC client and server library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
