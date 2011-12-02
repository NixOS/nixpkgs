{ cabal, hashable, text }:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "0.4";
  sha256 = "0la9gzf563x03xy120n8h5f6kmn425c5chbm42ksx1g7ag1ppmd6";
  buildDepends = [ hashable text ];
  meta = {
    homepage = "https://github.com/basvandijk/case-insensitive";
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
