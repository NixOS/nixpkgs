{cabal, HTTP, HaXml, blazeBuilder, dataenc, mtl, network,
 utf8String} :

cabal.mkDerivation (self : {
  pname = "haxr";
  version = "3000.8.4";
  sha256 = "0cyf1q1ngz0jqxdrvblcy9iw7l478v0rfr7bgkpq0l4brw0ca1pg";
  propagatedBuildInputs = [
    HTTP HaXml blazeBuilder dataenc mtl network utf8String
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/HaXR";
    description = "XML-RPC client and server library.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
