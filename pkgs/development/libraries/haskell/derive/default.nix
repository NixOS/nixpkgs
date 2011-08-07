{cabal, haskellSrcExts, syb, transformers, uniplate} :

cabal.mkDerivation (self : {
  pname = "derive";
  version = "2.5.2";
  sha256 = "03qmwy47xxpdwpfyf509bsh7ysh4y5lwxsn15jpbnz6mnssxn07y";
  propagatedBuildInputs = [
    haskellSrcExts syb transformers uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/derive/";
    description = "A program and library to derive instances for data types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
