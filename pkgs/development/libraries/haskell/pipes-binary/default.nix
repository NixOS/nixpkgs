{ cabal, binary, lensFamilyCore, pipes, pipesBytestring, pipesParse
, smallcheck, tasty, tastyHunit, tastySmallcheck, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-binary";
  version = "0.4.0";
  sha256 = "021shl5czrr82b06awy7biy93qf6nh0wwiadhr7qsawzdnzqz2vc";
  buildDepends = [
    binary pipes pipesBytestring pipesParse transformers
  ];
  testDepends = [
    binary lensFamilyCore pipes pipesParse smallcheck tasty tastyHunit
    tastySmallcheck transformers
  ];
  # Depends on an out-of-date version of smallcheck
  doCheck = false;
  meta = {
    homepage = "https://github.com/k0001/pipes-binary";
    description = "Encode and decode binary streams using the pipes and binary libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
