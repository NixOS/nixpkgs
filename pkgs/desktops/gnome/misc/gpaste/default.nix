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
, libadwaita
, meson
, mutter
, ninja
, pango
, pkg-config
, vala
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
    wrapGAppsHook
  ];

  buildInputs = [
    clutter # required by mutter-clutter
    gjs
    glib
    gtk3
    gtk4
    libadwaita
    mutter
    pango
  ];

  mesonFlags = [
    "-Dcontrol-center-keybindings-dir=${placeholder "out"}/share/gnome-control-center/keybindings"
    "-Ddbus-services-dir=${placeholder "out"}/share/dbus-1/services"
    "-Dsystemd-user-unit-dir=${placeholder "out"}/etc/systemd/user"
  ];

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  meta = with lib; {
    homepage = "https://github.com/Keruspe/GPaste";
    description = "Clipboard management system with GNOME 3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
