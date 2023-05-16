{ stdenv
, arrow-cpp
, fetchurl
, glib
, gobject-introspection
, lib
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "arrow-glib";
  inherit (arrow-cpp) src version;
  sourceRoot = "apache-arrow-${version}/c_glib";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
<<<<<<< HEAD
    gobject-introspection
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    arrow-cpp
    glib
<<<<<<< HEAD
=======
    gobject-introspection
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    inherit (arrow-cpp.meta) license platforms;
    description = "GLib bindings for Apache Arrow";
    homepage = "https://arrow.apache.org/docs/c_glib/";
    maintainers = with maintainers; [ amarshall ];
  };
}
