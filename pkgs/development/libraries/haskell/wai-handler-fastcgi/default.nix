{ cabal, fcgi, wai, waiExtra }:

cabal.mkDerivation (self: {
  pname = "wai-handler-fastcgi";
  version = "3.0.0";
  sha256 = "1cvy95qmbrhc1yjcral7f8y2929xp623abc9xasz7j28m4wwmynh";
  buildDepends = [ wai waiExtra ];
  extraLibraries = [ fcgi ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "Wai handler to fastcgi";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
