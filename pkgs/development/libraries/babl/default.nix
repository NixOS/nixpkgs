{ stdenv
, lib
, fetchpatch
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, lcms2
, vala
}:

stdenv.mkDerivation rec {
  pname = "babl";
<<<<<<< HEAD
  version = "0.1.106";
=======
  version = "0.1.102";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  src = fetchurl {
<<<<<<< HEAD
    url = "https://download.gimp.org/pub/babl/${lib.versions.majorMinor version}/babl-${version}.tar.xz";
    hash = "sha256-0yUTXTME8IjBNMxiABOs8DXeLl0SWlCi2RBU5zd8QV8=";
=======
    url = "https://download.gimp.org/pub/babl/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "a88bb28506575f95158c8c89df6e23686e50c8b9fea412bf49fe8b80002d84f0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
  ];

  buildInputs = [
    lcms2
  ];

  meta = with lib; {
    description = "Image pixel format conversion library";
    homepage = "https://gegl.org/babl/";
    changelog = "https://gitlab.gnome.org/GNOME/babl/-/blob/BABL_${lib.replaceStrings [ "." ] [ "_" ] version}/NEWS";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
  };
}
