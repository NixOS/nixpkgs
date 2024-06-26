{
  stdenv,
  arrow-cpp,
  glib,
  gobject-introspection,
  lib,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "arrow-glib";
  inherit (arrow-cpp) src version;
  sourceRoot = "apache-arrow-${version}/c_glib";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    arrow-cpp
    glib
  ];

  meta = with lib; {
    inherit (arrow-cpp.meta) license platforms;
    description = "GLib bindings for Apache Arrow";
    homepage = "https://arrow.apache.org/docs/c_glib/";
    maintainers = with maintainers; [ amarshall ];
  };
}
