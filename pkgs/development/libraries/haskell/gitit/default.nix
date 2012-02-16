{ cabal, cgi, ConfigFile, feed, filepath, filestore, ghcPaths
, happstackServer, happstackUtil, highlightingKate, hslogger
, HStringTemplate, HTTP, json, mtl, network, pandoc, pandocTypes
, parsec, random, recaptcha, safe, SHA, syb, text, time, url
, utf8String, xhtml, xml, xssSanitize, zlib
}:

cabal.mkDerivation (self: {
  pname = "gitit";
  version = "0.8.1";
  sha256 = "1b5i6fm68vwhlvgz0m7xxzklkxc2c6lrqyqfqyjs93p5j0aqgvfn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cgi ConfigFile feed filepath filestore ghcPaths happstackServer
    happstackUtil highlightingKate hslogger HStringTemplate HTTP json
    mtl network pandoc pandocTypes parsec random recaptcha safe SHA syb
    text time url utf8String xhtml xml xssSanitize zlib
  ];
  meta = {
    homepage = "http://gitit.net";
    description = "Wiki using happstack, git or darcs, and pandoc";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
