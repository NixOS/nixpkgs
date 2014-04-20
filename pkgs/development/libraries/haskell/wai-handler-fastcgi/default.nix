{ cabal, fcgi, wai, waiExtra }:

cabal.mkDerivation (self: {
  pname = "wai-handler-fastcgi";
  version = "2.0.0.1";
  sha256 = "14jsibsqfj6z5yqgdrh43aiqps1yldxkgn6fkj4i80zxk099nbxp";
  buildDepends = [ wai waiExtra ];
  extraLibraries = [ fcgi ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "Wai handler to fastcgi";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
