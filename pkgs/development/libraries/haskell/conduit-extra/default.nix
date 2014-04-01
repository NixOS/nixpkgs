{ cabal }:

cabal.mkDerivation (self: {
  pname = "conduit-extra";
  version = "1.0.0";
  sha256 = "120c3zay8svdw3b9nqgxlrj45a1d4xf0sijkg367m7hp22szvz8a";
  noHaddock = true;
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Temporary placeholder package";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
