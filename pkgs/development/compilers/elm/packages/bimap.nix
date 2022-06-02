{ mkDerivation, base, containers, exceptions, lib, QuickCheck
, template-haskell
}:
mkDerivation {
  pname = "bimap";
  version = "0.3.3";
  sha256 = "73829355c7bcbd3eedba22a382a04a3ab641702b00828790ec082ec2db3a8ad1";
  libraryHaskellDepends = [ base containers exceptions ];
  testHaskellDepends = [
    base containers exceptions QuickCheck template-haskell
  ];
  homepage = "https://github.com/joelwilliamson/bimap";
  description = "Bidirectional mapping between two key types";
  license = lib.licenses.bsd3;
}
