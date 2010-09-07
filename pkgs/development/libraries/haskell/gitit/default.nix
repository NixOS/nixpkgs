{cabal, happstackServer, happstackUtil, HStringTemplate, HTTP,
 SHA, cgi, datetime,
 filestore, highlightingKate, safe, mtl, network, pandoc, parsec,
 recaptcha, utf8String, xhtml, zlib, ConfigFile, url,
 cautiousFile, feed}:

cabal.mkDerivation (self : {
  pname = "gitit";
  version = "0.7.3.8";
  sha256 = "356c82604dcfe2eec4faeb36ee46546ea3e26738780723f457366b2e35f6211a";
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

