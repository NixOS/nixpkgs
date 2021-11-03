{ qtModule
, qtbase
, libglvnd, libxkbcommon, vulkan-headers # TODO should be inherited from qtbase
, wayland
}:

# TODO? enable more Qt Wayland Drivers

qtModule {
  pname = "qtwayland";
  qtInputs = [ qtbase ];
  buildInputs = [ wayland libglvnd libxkbcommon vulkan-headers ];
  hasPlugins = true;
}
