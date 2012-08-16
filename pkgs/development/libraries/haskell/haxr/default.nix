{ cabal, base64Bytestring, blazeBuilder, HaXml, HTTP, mtl, network
, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "haxr";
  version = "3000.9.0.1";
  sha256 = "106hw8ysjx12dvwij4ld6n54mxj2yl1p7iihp2fwz50v50mz6102";
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
