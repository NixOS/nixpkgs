{ cabal, base64Bytestring, blazeHtml, extensibleExceptions
, filepath, hslogger, html, HUnit, monadControl, mtl, network
, parsec, sendfile, syb, systemFilepath, text, threads, time
, timeCompat, transformers, transformersBase, utf8String, xhtml
, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "7.3.2";
  sha256 = "11wnnadxy1j786p81nkvd28vgpjjhm1amy34k5r0ynz0nkanfp3z";
  buildDepends = [
    base64Bytestring blazeHtml extensibleExceptions filepath hslogger
    html monadControl mtl network parsec sendfile syb systemFilepath
    text threads time timeCompat transformers transformersBase
    utf8String xhtml zlib
  ];
  testDepends = [ HUnit parsec zlib ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://happstack.com";
    description = "Web related tools and services";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
