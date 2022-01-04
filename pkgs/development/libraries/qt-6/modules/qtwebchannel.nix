{ qtModule
, qtbase
, qtdeclarative
, qtwebsockets
, openssl

, libglvnd, libxkbcommon, vulkan-headers, libX11, libXcomposite
}:

qtModule {
  pname = "qtwebchannel";
  qtInputs = [ qtbase qtdeclarative qtwebsockets ];
  buildInputs = [
    openssl
    # FIXME should be propagated by qtbase
    libglvnd libxkbcommon vulkan-headers libX11 libXcomposite
  ];
  outputs = [ "out" "dev" ];
  # FIXME qt6: set this automatically
  preConfigure = ''
    export QT_ADDITIONAL_PACKAGES_PREFIX_PATH="${qtdeclarative.dev}:${qtwebsockets.dev}"
  '';
}
