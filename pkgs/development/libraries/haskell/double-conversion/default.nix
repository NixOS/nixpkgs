{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "double-conversion";
  version = "0.2.0.5";
  sha256 = "1z23a8sfnq5lady8n2kcina9a7df8lmsliscf85x84dxkd3a1ahf";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/bos/double-conversion";
    description = "Fast conversion between double precision floating point and text";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
