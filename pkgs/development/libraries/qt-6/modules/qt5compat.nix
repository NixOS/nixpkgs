{ qtModule
, qtbase
, libglvnd, libxkbcommon, vulkan-headers # TODO should be inherited from qtbase
, libiconv
# FIXME Configure summary: qt5compat is not using libiconv. bug in qt6?
, icu
, openssl
}:

qtModule {
  pname = "qt5compat";
  qtInputs = [ qtbase ]; # TODO qtquick
  buildInputs = [ libiconv icu openssl openssl.dev libglvnd libxkbcommon vulkan-headers ];
  outputs = [ "out" "dev" ];
}
