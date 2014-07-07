{ cabal }:

cabal.mkDerivation (self: {
  pname = "pretty";
  version = "1.1.1.1";
  sha256 = "1rjpqa4grhamzn5s9xg4w16cz2dpkn7ii9bpqy8lg4fiwppvg2kb";

  doCheck = false;

  meta = {
    description = "Pretty printing library especially useful for compilers and related tools";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
