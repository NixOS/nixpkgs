{ qtModule
, qtbase
, libglvnd, libxkbcommon, vulkan-headers # TODO should be inherited from qtbase
, qtdeclarative # TODO verify
, openssl
}:

qtModule {
  pname = "qtquick3d";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ openssl openssl.dev libglvnd libxkbcommon vulkan-headers ];
  outputs = [ "out" "dev" "bin" ];
}
