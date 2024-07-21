{ lib
, stdenv
, fetchurl
, substituteAll
, pkg-config
, libxslt
, ninja
, gnome
, gtk3
, gtk4
, glib
, gettext
, libxml2
, xkeyboard_config
, libxkbcommon
, isocodes
, meson
, wayland
, libseccomp
, systemd
, bubblewrap
, gobject-introspection
, gtk-doc
, docbook-xsl-nons
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "gnome-desktop";
  version = "44.0";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-desktop/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-QsdzdF2EuhS8HPHExvRgYUiAOlzTN5QcY5ZHlfPFnUI=";
  };

  patches = lib.optionals stdenv.isLinux [
    (substituteAll {
      src = ./bubblewrap-paths.patch;
      bubblewrap_bin = "${bubblewrap}/bin/bwrap";
      inherit (builtins) storeDir;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    libxslt
    libxml2
    gobject-introspection
    gtk-doc
    docbook-xsl-nons
    glib
  ];

  buildInputs = [
    xkeyboard_config
    libxkbcommon # for xkbregistry
    isocodes
    gtk3
    gtk4
    glib
  ] ++ lib.optionals stdenv.isLinux [
    bubblewrap
    wayland
    libseccomp
    systemd
  ];

  propagatedBuildInputs = [
    gsettings-desktop-schemas
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Ddesktop_docs=false"
  ] ++ lib.optionals (!stdenv.isLinux) [
    "-Dsystemd=disabled"
    "-Dudev=disabled"
  ];

  separateDebugInfo = stdenv.isLinux;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-desktop";
    };
  };

  meta = with lib; {
    description = "Library with common API for various GNOME modules";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-desktop";
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
