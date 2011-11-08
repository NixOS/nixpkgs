{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "system-filepath";
  version = "0.4.3";
  sha256 = "16a57dipz3aid5n22gzyd9yqmsxm98c3s6vb7minj82q9rbl5z67";
  buildDepends = [ deepseq text ];
  meta = {
    homepage = "https://john-millikin.com/software/hs-filepath/";
    description = "High-level, byte-based file and directory path manipulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
