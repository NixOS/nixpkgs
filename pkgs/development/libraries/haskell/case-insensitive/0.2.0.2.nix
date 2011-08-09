{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "0.2.0.2";
  sha256 = "0qn2scaxxbqi4770nwvcmb1ldj0ipa2ljxcavcn0kv48xzs519l7";
  buildDepends = [ text ];
  meta = {
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
