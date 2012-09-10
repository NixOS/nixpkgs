{ cabal, base64Bytestring, blazeHtml, extensibleExceptions
, filepath, hslogger, html, monadControl, mtl, network, parsec
, sendfile, syb, systemFilepath, text, time, transformers
, transformersBase, utf8String, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "7.0.4";
  sha256 = "168201z5slm6mrkckpdpshgaiz29k9j1j97vmbrybprj0zhcrl7r";
  buildDepends = [
    base64Bytestring blazeHtml extensibleExceptions filepath hslogger
    html monadControl mtl network parsec sendfile syb systemFilepath
    text time transformers transformersBase utf8String xhtml zlib
  ];
  jailbreak = true;
  meta = {
    homepage = "http://happstack.com";
    description = "Web related tools and services";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
