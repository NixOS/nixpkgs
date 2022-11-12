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
  version = "43.0";
  pname = "gpaste";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "GPaste";
    rev = "v${version}";
    sha256 = "sha256-F+AWTYVK145RzJ1Zldh4Q4R/hN/D7aXO3SIJ1t6ClWs=";
  };

  patches = [
    ./fix-paths.patch

    # Build against GCR 4.
    # Patch was temporarily reverted.
    # https://github.com/Keruspe/GPaste/pull/409
    (fetchpatch {
      url = "https://github.com/Keruspe/GPaste/commit/0378cb4a657042ce5321f1d9728cff31e55bede6.patch";
      sha256 = "0Ngr+/fS5/wICR84GEiE0pXEXQ/f/3G59lDivH167m8=";
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
