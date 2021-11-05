{ qtModule
, qtbase
, libglvnd, libxkbcommon, vulkan-headers # TODO should be inherited from qtbase
, qtdeclarative # TODO verify
, libiconv
# FIXME Configure summary: qt5compat is not using libiconv. bug in qt6?
, icu
, openssl
}:

qtModule {
  pname = "qt5compat";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ libiconv icu openssl openssl.dev libglvnd libxkbcommon vulkan-headers ];
}
