{ cabal }:

cabal.mkDerivation (self: {
  pname = "data-ordlist";
  version = "0.4.6.1";
  sha256 = "1qrvyin5567br99zfip7krdy6snnbm5z5jdi6ghmk0cfmhmyrwy3";
  meta = {
    description = "Set and bag operations on ordered lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
