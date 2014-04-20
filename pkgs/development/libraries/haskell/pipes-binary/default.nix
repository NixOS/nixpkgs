{ cabal, binary, lensFamilyCore, pipes, pipesBytestring, pipesParse
, smallcheck, tasty, tastyHunit, tastySmallcheck, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-binary";
  version = "0.4.0.1";
  sha256 = "1vwsr446b3ysjm86bmpmq8pg2badx9xn0iyr17r4mby0bxvvld33";
  buildDepends = [
    binary pipes pipesBytestring pipesParse transformers
  ];
  testDepends = [
    binary lensFamilyCore pipes pipesParse smallcheck tasty tastyHunit
    tastySmallcheck transformers
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/k0001/pipes-binary";
    description = "Encode and decode binary streams using the pipes and binary libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
