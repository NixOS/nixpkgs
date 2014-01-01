{ cabal, fcgi, wai, waiExtra }:

cabal.mkDerivation (self: {
  pname = "wai-handler-fastcgi";
  version = "2.0.0";
  sha256 = "1pqiqx1wq2iv705f8bd4sxmjmmkkxiw4g6a9dpwnawwb5n0d88nl";
  buildDepends = [ wai waiExtra ];
  extraLibraries = [ fcgi ];
  meta = {
    homepage = "http://www.yesodweb.com/book/web-application-interface";
    description = "Wai handler to fastcgi";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
