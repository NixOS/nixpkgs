{cabal, happstackServer, happstackUtil, HStringTemplate, HTTP,
 SHA, cgi, datetime,
 filestore, highlightingKate, safe, mtl, network, pandoc, parsec,
 recaptcha, utf8String, xhtml, zlib, ConfigFile, url,
 cautiousFile, feed}:

cabal.mkDerivation (self : {
  pname = "gitit";
  version = "0.7.3.5";
  sha256 = "50cf6b853d439904e54884660eba6ffdc31b938e077fd0d9457fba972d4bde9f";
  propagatedBuildInputs = [
    HStringTemplate happstackServer happstackUtil HTTP SHA cgi datetime
    filestore highlightingKate safe
    mtl network pandoc parsec recaptcha utf8String xhtml zlib ConfigFile
    url cautiousFile feed
  ];
  meta = {
    description = "Wiki using HAppS, git or darcs, and pandoc";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

