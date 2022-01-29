{ qtModule
, lib
, stdenv
, qtbase
, qtdeclarative
, bluez
, pkg-config
}:

qtModule {
  pname = "qtconnectivity";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = lib.optional stdenv.isLinux bluez;
  nativeBuildInputs = [ pkg-config ]; # find bluez
  outputs = [ "out" "dev" ];
}
