{cabal}:

cabal.mkDerivation (self : {
  pname = "random-shuffle";
  version = "0.0.2";
  sha256 = "1csq0ffsqbbv6ymf707nzfb7c9bmykwk9bcgj21mxmh6khlqn9jp";
  meta = {
    description = "Random shuffle implementation";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

