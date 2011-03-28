{cabal, happstackServer, happstackUtil, HStringTemplate, HTTP,
 SHA, cgi, datetime,
 filestore, highlightingKate, safe, mtl, network, pandoc, parsec,
 recaptcha, utf8String, xhtml, zlib, ConfigFile, url,
 cautiousFile, feed, xssSanitize}:

cabal.mkDerivation (self : {
  pname = "gitit";
  version = "0.7.3.12";
  sha256 = "1z5cbkgfvwc9h6jciw7ghlj9ra6xph5z4lmliwkdnf38wfparxja";
  propagatedBuildInputs = [
    HStringTemplate happstackServer happstackUtil HTTP SHA cgi datetime
    filestore highlightingKate safe
    mtl network pandoc parsec recaptcha utf8String xhtml zlib ConfigFile
    url cautiousFile feed xssSanitize
  ];
  meta = {
    description = "Wiki using happstack, git or darcs, and pandoc";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

