{ cabal }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.4.4";
  sha256 = "1czwa5vpafhvif4gv7bwa7hrxkrbrvvybgyjckd0hdpl6bpd4nhp";
  meta = {
    homepage = "https://github.com/snoyberg/file-embed";
    description = "Use Template Haskell to embed file contents directly";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
