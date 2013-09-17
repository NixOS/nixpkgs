{ cabal, binary, dlist }:

cabal.mkDerivation (self: {
  pname = "list-tries";
  version = "0.5.1";
  sha256 = "15lbq41rikj5vm9gfgjxz98pamnib4dcs48fr2vm9r3s3fikd2kz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary dlist ];
  meta = {
    homepage = "http://iki.fi/matti.niemenmaa/list-tries/";
    description = "Tries and Patricia tries: finite sets and maps for list keys";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
