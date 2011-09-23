{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "system-filepath";
  version = "0.4.1";
  sha256 = "0jb32516xiwgbvr68yrf142fnzxfhn2dwh48nfr06gz65l7y4fcx";
  buildDepends = [ text ];
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
