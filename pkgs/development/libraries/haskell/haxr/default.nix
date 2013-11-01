{ cabal, base64Bytestring, blazeBuilder, HaXml, HTTP, mtl, network
, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haxr";
  version = "3000.10.1.1";
  sha256 = "0qvbl3bms2mf650w9j3r0pnl151vzkggy2if3f4rj34qwb2sxmvp";
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
