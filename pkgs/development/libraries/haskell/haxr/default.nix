{ cabal, base64Bytestring, blazeBuilder, HaXml, HTTP, mtl, network
, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haxr";
  version = "3000.10.2";
  sha256 = "10fgz1vvrx09pvlxp0k772xbfni8c8lxbjp59vzm95v2kc4hnagc";
  buildDepends = [
    base64Bytestring blazeBuilder HaXml HTTP mtl network time
    utf8String
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/HaXR";
    description = "XML-RPC client and server library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
