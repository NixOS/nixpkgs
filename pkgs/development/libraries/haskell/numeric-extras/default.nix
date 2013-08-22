{ cabal }:

cabal.mkDerivation (self: {
  pname = "numeric-extras";
  version = "0.0.3";
  sha256 = "18jyjrk6iizz3sgkwgbh1rxf6zdf166bkgs7wia8b4z7f6261nzg";
  meta = {
    homepage = "http://github.com/ekmett/numeric-extras";
    description = "Useful tools from the C standard library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
