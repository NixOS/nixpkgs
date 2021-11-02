{ pkg-config
, qtModule
, qtbase
, wayland
, libglvnd
, libxkbcommon
, vulkan-headers
}:

qtModule {
  pname = "qtwayland";
  qtInputs = [ qtbase ];
  buildInputs = [ wayland libglvnd libxkbcommon vulkan-headers ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" ];
}
