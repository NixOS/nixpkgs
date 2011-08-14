{ cabal, fclabels, MaybeTTransformers, monadsFd, network, pureMD5
, random, safe, salviaProtocol, split, stm, text, threadmanager
, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "salvia";
  version = "1.0.0";
  sha256 = "d1be63e3eb7cb071e8e339d730692b3ce52576e513f718b89a194b17878496e1";
  buildDepends = [
    fclabels MaybeTTransformers monadsFd network pureMD5 random safe
    salviaProtocol split stm text threadmanager time transformers
    utf8String
  ];
  meta = {
    description = "Modular web application framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
