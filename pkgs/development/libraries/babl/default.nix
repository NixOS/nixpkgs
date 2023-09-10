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
  version = "0.1.106";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://download.gimp.org/pub/babl/${lib.versions.majorMinor version}/babl-${version}.tar.xz";
    hash = "sha256-0yUTXTME8IjBNMxiABOs8DXeLl0SWlCi2RBU5zd8QV8=";
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
