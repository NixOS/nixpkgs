{ cabal, base64Bytestring, blazeHtml, cgi, ConfigFile, feed
, filepath, filestore, ghcPaths, happstackServer, highlightingKate
, hslogger, HStringTemplate, HTTP, json, mtl, network, pandoc
, pandocTypes, parsec, random, recaptcha, safe, SHA, syb, tagsoup
, text, time, url, utf8String, xhtml, xml, xssSanitize, zlib
}:

cabal.mkDerivation (self: {
  pname = "gitit";
  version = "0.10.1.2";
  sha256 = "1dy1wdnld6cxx5xqfszywi4f7xv143ar2dq4nb0dnd1dgd5hgmak";
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
