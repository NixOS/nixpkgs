{ cabal, numericExtras }:

cabal.mkDerivation (self: {
  pname = "intervals";
  version = "0.2.2";
  sha256 = "059xmk373xz6nwk61iyhx4d7xd328jxb694qmq9plry3k77mdh5q";
  buildDepends = [ numericExtras ];
  meta = {
    homepage = "http://github.com/ekmett/intervals";
    description = "Interval Arithmetic";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
