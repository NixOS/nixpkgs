{ cabal, blazeHtml, cgi, ConfigFile, feed, filepath, filestore
, ghcPaths, happstackServer, happstackUtil, highlightingKate
, hslogger, HStringTemplate, HTTP, json, mtl, network, pandoc
, pandocTypes, parsec, random, recaptcha, safe, SHA, syb, tagsoup
, text, time, url, utf8String, xhtml, xml, xssSanitize, zlib
}:

cabal.mkDerivation (self: {
  pname = "gitit";
  version = "0.9";
  sha256 = "00kjfmczj5m3b8r8djdpad8d27s44z7pf76yyc0sdja1f3bd4mlp";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml cgi ConfigFile feed filepath filestore ghcPaths
    happstackServer happstackUtil highlightingKate hslogger
    HStringTemplate HTTP json mtl network pandoc pandocTypes parsec
    random recaptcha safe SHA syb tagsoup text time url utf8String
    xhtml xml xssSanitize zlib
  ];
  meta = {
    homepage = "http://gitit.net";
    description = "Wiki using happstack, git or darcs, and pandoc";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
