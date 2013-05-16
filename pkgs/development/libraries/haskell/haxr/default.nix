{ cabal, base64Bytestring, blazeBuilder, HaXml, HTTP, mtl, network
, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haxr";
  version = "3000.9.2.1";
  sha256 = "065kkqa8wjh5qncjx7x83nxvmk338g8xzl4rjbczga6l3dpy0f24";
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
