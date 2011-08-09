{ cabal, ConfigFile, HStringTemplate, HTTP, SHA, cgi, feed
, filestore, ghcPaths, happstackServer, happstackUtil
, highlightingKate, hslogger, json, mtl, network, pandoc
, pandocTypes, parsec, recaptcha, safe, syb, time, url, utf8String
, xhtml, xml, xssSanitize, zlib
}:

cabal.mkDerivation (self: {
  pname = "gitit";
  version = "0.8.0.1";
  sha256 = "0y2gcxlbb44vflj0jl3zkbsn47n7nccikxwdw6ccf9kxgcmrz0zy";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ConfigFile HStringTemplate HTTP SHA cgi feed filestore ghcPaths
    happstackServer happstackUtil highlightingKate hslogger json mtl
    network pandoc pandocTypes parsec recaptcha safe syb time url
    utf8String xhtml xml xssSanitize zlib
  ];
  meta = {
    homepage = "http://github.com/jgm/gitit/tree/master";
    description = "Wiki using happstack, git or darcs, and pandoc.";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
