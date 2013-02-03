{ cabal }:

cabal.mkDerivation (self: {
  pname = "threadmanager";
  version = "0.1.5";
  sha256 = "0jdr0rrpx7frnh0a2vibg0170w48wvn6gv8imkiqiz6y6481ny5p";
  meta = {
    homepage = "http://github.com/bsl/threadmanager";
    description = "Simple thread management";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
