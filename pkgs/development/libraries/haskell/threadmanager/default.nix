{cabal}:

cabal.mkDerivation (self : {
  pname = "threadmanager";
  version = "0.1.3";
  sha256 = "22ca45d7e32518736abb9cde6d2d14163128888769fc02bbc2641fd97318a15a";
  meta = {
    description = "Simple thread management";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

