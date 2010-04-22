{cabal, fclabels, MaybeTTransformers, monadsFd, pureMD5, safe,
 salviaProtocol, split, text, threadmanager, transformers, utf8String,
 network, stm, time}:

cabal.mkDerivation (self : {
  pname = "salvia";
  version = "1.0.0";
  sha256 = "d1be63e3eb7cb071e8e339d730692b3ce52576e513f718b89a194b17878496e1";
  propagatedBuildInputs = [
    fclabels MaybeTTransformers monadsFd pureMD5 safe salviaProtocol
    split text threadmanager transformers utf8String network stm time
  ];
  meta = {
    description = "Modular web application framework";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

