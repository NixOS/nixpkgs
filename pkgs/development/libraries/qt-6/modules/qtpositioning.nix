{ qtModule
, qtbase
, libwebp
, jasper
, libmng
, zlib
, pkg-config
, openssl
, qtserialport
, qtdeclarative

, libglvnd, libxkbcommon, vulkan-headers, libX11, libXcomposite
}:

qtModule {
  pname = "qtpositioning";
  qtInputs = [ qtbase qtserialport ];
  #buildInputs = [ libwebp jasper libmng zlib libglvnd libxkbcommon vulkan-headers ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    # FIXME should be propagated by qtbase
    libglvnd libxkbcommon vulkan-headers libX11 libXcomposite
  ];
  # FIXME qt6: set this automatically
  preConfigure = ''
    export QT_ADDITIONAL_PACKAGES_PREFIX_PATH="${qtdeclarative.dev}:${qtserialport.dev}"
  '';
  outputs = [ "out" "dev" "bin" ];
}

/*
-- The following OPTIONAL packages have not been found:

 * Qt6QmlCompilerPlus
 * Gypsy
 * Gconf
*/
