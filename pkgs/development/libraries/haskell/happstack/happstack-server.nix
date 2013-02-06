{ cabal, base64Bytestring, blazeHtml, extensibleExceptions
, filepath, hslogger, html, monadControl, mtl, network, parsec
, sendfile, syb, systemFilepath, text, threads, time, timeCompat
, transformers, transformersBase, utf8String, xhtml, zlib
}:

cabal.mkDerivation (self: {
  pname = "happstack-server";
  version = "7.1.2";
  sha256 = "1pqrwsgdp1qf5jd2nzdrj2wkd2bq9n0ciwyzvzn8nmwyqgkdzs4f";
  buildDepends = [
    base64Bytestring blazeHtml extensibleExceptions filepath hslogger
    html monadControl mtl network parsec sendfile syb systemFilepath
    text threads time timeCompat transformers transformersBase
    utf8String xhtml zlib
  ];
  meta = {
    homepage = "http://happstack.com";
    description = "Web related tools and services";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
