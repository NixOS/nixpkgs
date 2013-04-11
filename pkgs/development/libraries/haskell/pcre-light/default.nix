{ cabal, pcre }:

cabal.mkDerivation (self: {
  pname = "pcre-light";
  version = "0.4";
  sha256 = "1xiikiap1bvx9czw64664vifdq64scx0yhfclh5m8mkvn3x6yzxk";
  extraLibraries = [ pcre ];
  meta = {
    homepage = "http://code.haskell.org/~dons/code/pcre-light";
    description = "A small, efficient and portable regex library for Perl 5 compatible regular expressions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
