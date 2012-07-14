{ cabal, base64Bytestring, blazeHtml, cgi, ConfigFile, feed
, filepath, filestore, ghcPaths, happstackServer, highlightingKate
, hslogger, HStringTemplate, HTTP, json, mtl, network, pandoc
, pandocTypes, parsec, random, recaptcha, safe, SHA, syb, tagsoup
, text, time, url, utf8String, xhtml, xml, xssSanitize, zlib
}:

cabal.mkDerivation (self: {
  pname = "gitit";
  version = "0.10.0.1";
  sha256 = "0dx4jq7j0s6h5lfl8qrr4qnyb3j0cnnc1c786yf8kcmhk04n028f";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml cgi ConfigFile feed filepath filestore
    ghcPaths happstackServer highlightingKate hslogger HStringTemplate
    HTTP json mtl network pandoc pandocTypes parsec random recaptcha
    safe SHA syb tagsoup text time url utf8String xhtml xml xssSanitize
    zlib
  ];
  meta = {
    homepage = "http://gitit.net";
    description = "Wiki using happstack, git or darcs, and pandoc";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
