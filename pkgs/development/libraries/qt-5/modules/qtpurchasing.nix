{ stdenv
, lib
, qtModule
, qtbase
, qtdeclarative
, StoreKit
, Foundation
}:

qtModule {
  pname = "qtpurchasing";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Foundation StoreKit ];
}
