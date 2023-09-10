{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, wrapGAppsHook
, python3
, gettext
, gnome
, glib
, gtk3
, libgnome-games-support
, gdk-pixbuf
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atomix";
  version = "44.0";

  src = fetchurl {
    url = "mirror://gnome/sources/atomix/${lib.versions.major finalAttrs.version}/atomix-${finalAttrs.version}.tar.xz";
    sha256 = "yISTF2iNh9pzTJBjA1YxBSAH8qh5m2xsyRUmWIC1X7Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    glib
    gtk3
    gdk-pixbuf
    libgnome-games-support
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "atomix";
      attrPath = "gnome.atomix";
    };
  };

  meta = with lib; {
    description = "Puzzle game where you move atoms to build a molecule";
    homepage = "https://wiki.gnome.org/Apps/Atomix";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
})
