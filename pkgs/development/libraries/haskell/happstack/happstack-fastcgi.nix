{ cabal, cgi, fastcgi, happstackServer, mtl, utf8String }:

cabal.mkDerivation (self: {
  pname = "happstack-fastcgi";
  version = "0.1.4";
  sha256 = "0jgrwvqlskphp0ixvyvg09d7xfm1brxyjr4dlaq235n6v7f0kvmb";
  buildDepends = [ cgi fastcgi happstackServer mtl utf8String ];
  patches = [ ./HttpVersion.patch ];
  /*patchPhase = ''*/
    /*substituteInPlace src/Happstack/Server/FastCGI.hs --replace "Happstack.Server.HTTP.Types" "Happstack.Server.Types" \*/
        /*--replace "*/

    /*'';*/
  meta = {
    description = "Happstack extension for use with FastCGI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.tomberek ];
  };
})
