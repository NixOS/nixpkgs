{cabal, network, tagsoup, utf8String}:

cabal.mkDerivation (self : {
  pname = "xss-sanitize";
  version = "0.2.6";
  sha256 = "18bkvrrkc0ga0610f8g3vghq0ib1yczn2n2zbzv7kg7m6bqgx2y5";
  propagatedBuildInputs = [network tagsoup utf8String];
  meta = {
    description = "sanitize untrusted HTML to prevent XSS attacks";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

