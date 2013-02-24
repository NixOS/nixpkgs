{ cabal, base64Bytestring, blazeHtml, cgi, ConfigFile, feed
, filepath, filestore, ghcPaths, happstackServer, highlightingKate
, hslogger, HStringTemplate, HTTP, json, mtl, network, pandoc
, pandocTypes, parsec, random, recaptcha, safe, SHA, syb, tagsoup
, text, time, url, utf8String, xhtml, xml, xssSanitize, zlib
}:

cabal.mkDerivation (self: {
  pname = "gitit";
  version = "0.10.2";
  sha256 = "07zdc1qx429rmisb39gdamwn9b1jblvjg7py4fcxx3qj01b6mvxx";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml cgi ConfigFile feed filepath filestore
    ghcPaths happstackServer highlightingKate hslogger HStringTemplate
    HTTP json mtl network pandoc pandocTypes parsec random recaptcha
    safe SHA syb tagsoup text time url utf8String xhtml xml xssSanitize
    zlib
  ];
  jailbreak = true;
  meta = {
    homepage = "http://gitit.net";
    description = "Wiki using happstack, git or darcs, and pandoc";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
