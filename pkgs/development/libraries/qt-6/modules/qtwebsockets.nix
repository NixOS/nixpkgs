{ qtModule
, qtbase
, qtdeclarative
, openssl

, libglvnd, libxkbcommon, vulkan-headers, libX11, libXcomposite
}:

qtModule {
  pname = "qtwebsockets";
  qtInputs = [ qtbase qtdeclarative ];
  outputs = [ "out" "dev" ];
  buildInputs = [
    openssl
    # FIXME should be propagated by qtbase
    libglvnd libxkbcommon vulkan-headers libX11 libXcomposite
  ];
  # FIXME qt6: set this automatically
  preConfigure = ''
    export QT_ADDITIONAL_PACKAGES_PREFIX_PATH="${qtdeclarative.dev}"
  '';
}
