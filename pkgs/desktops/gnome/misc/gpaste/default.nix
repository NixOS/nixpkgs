{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, appstream-glib
, clutter
, gjs
, glib
, gobject-introspection
, gtk3
, gtk4
, gcr_4
, libadwaita
, meson
, mutter
, ninja
, pango
, pkg-config
, vala
, desktop-file-utils
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "42.1";
  pname = "gpaste";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "GPaste";
    rev = "v${version}";
    sha256 = "sha256-A5NZ4NiPVZUr7vPdDuNywLsLrejZ4SCg7+3//ZNRmLY=";
  };

  patches = [
    ./fix-paths.patch

    # Fix GNOME 43 compatibility.
    (fetchpatch {
      url = "https://github.com/Keruspe/GPaste/commit/eece9c374a823234bc20e58bf95bb10ace9590f4.patch";
      sha256 = "+GoiNsge+ki2X3OIoFA+r3K8WLN00nExYj8gDuCSNiA=";
    })
    (fetchpatch {
      url = "https://github.com/Keruspe/GPaste/commit/614bbe65e7d8f2ddca447daaada86156334bb71a.patch";
      sha256 = "q6fjBTVRx6/5xf5ZhQJpvnwvroLiNxF73P7vTFTmNqI=";
    })
    (fetchpatch {
      url = "https://github.com/Keruspe/GPaste/commit/971e690a74b4de6b78bdaf1300507a6190ffb474.patch";
      sha256 = "bCLnuLqLgq7BlZN49NFrQjbCJBneVHl1t+WnAAIofkY=";
    })
    (fetchpatch {
      url = "https://github.com/Keruspe/GPaste/commit/0378cb4a657042ce5321f1d9728cff31e55bede6.patch";
      sha256 = "0Ngr+/fS5/wICR84GEiE0pXEXQ/f/3G59lDivH167m8=";
    })
    (fetchpatch {
      url = "https://github.com/Keruspe/GPaste/commit/6d29385f8c935b1def28340bc165ca6a7756f29b.patch";
      sha256 = "crkkIrLwogRzr1JfJEt5TPK65Y4zY1H5Gt+s0z3A8Dg=";
    })
  ];

  # TODO: switch to substituteAll with placeholder
  # https://github.com/NixOS/nix/issues/1846
  postPatch = ''
    substituteInPlace src/gnome-shell/extension.js \
      --subst-var-by typelibPath "${placeholder "out"}/lib/girepository-1.0"
    substituteInPlace src/gnome-shell/prefs.js \
      --subst-var-by typelibPath "${placeholder "out"}/lib/girepository-1.0"
    substituteInPlace src/libgpaste/gpaste/gpaste-settings.c \
      --subst-var-by gschemasCompiled ${glib.makeSchemaPath (placeholder "out") "${pname}-${version}"}
  '';

  nativeBuildInputs = [
    appstream-glib
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    clutter # required by mutter-clutter
    gjs
    glib
    gtk3
    gtk4
    gcr_4
    libadwaita
    mutter
    pango
  ];

  mesonFlags = [
    "-Dcontrol-center-keybindings-dir=${placeholder "out"}/share/gnome-control-center/keybindings"
    "-Ddbus-services-dir=${placeholder "out"}/share/dbus-1/services"
    "-Dsystemd-user-unit-dir=${placeholder "out"}/etc/systemd/user"
  ];

  meta = with lib; {
    homepage = "https://github.com/Keruspe/GPaste";
    description = "Clipboard management system with GNOME 3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
