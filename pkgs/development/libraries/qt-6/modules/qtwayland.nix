{ qtModule
, qtbase

, libglvnd, libxkbcommon, vulkan-headers, libX11, libXcomposite
# TODO should be inherited from qtbase

, wayland
, pkg-config
, xlibs
}:

qtModule {
  pname = "qtwayland";
  qtInputs = [ qtbase ];
  buildInputs = [ wayland pkg-config xlibs.libxcb xlibs.libxcb.dev
    libglvnd libxkbcommon vulkan-headers libX11 libXcomposite ];
  hasPlugins = true;
}
