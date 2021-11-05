{ qtModule
, qtbase
, libglvnd, vulkan-headers # TODO should be inherited from qtbase
, qtdeclarative # TODO verify
}:

qtModule {
  pname = "qtquicktimeline";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ libglvnd libxkbcommon vulkan-headers ];
  outputs = [ "out" "dev" "bin" ];
}
