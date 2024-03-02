{ stdenv
, lib
, fetchFromGitHub
, gjs
, glib
, gobject-introspection
, gtk3
, gtk4
, gcr_4
, libadwaita
, meson
, ninja
, pango
, pkg-config
, vala
, desktop-file-utils
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "45";
  pname = "gpaste";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "GPaste";
    rev = "v${version}";
    sha256 = "sha256-MpoeLXGdLfas/E3x5ojJW5Dd3H8XZORtFaBHgRGJXxg=";
  };

  patches = [
    ./fix-paths.patch
  ];

  # TODO: switch to substituteAll with placeholder
  # https://github.com/NixOS/nix/issues/1846
  postPatch = ''
    substituteInPlace src/libgpaste/gpaste/gpaste-settings.c \
      --subst-var-by gschemasCompiled ${glib.makeSchemaPath (placeholder "out") "${pname}-${version}"}
  '';

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    gjs
    glib
    gtk3
    gtk4
    gcr_4
    libadwaita
    pango
  ];

  mesonFlags = [
    "-Dcontrol-center-keybindings-dir=${placeholder "out"}/share/gnome-control-center/keybindings"
    "-Ddbus-services-dir=${placeholder "out"}/share/dbus-1/services"
    "-Dsystemd-user-unit-dir=${placeholder "out"}/etc/systemd/user"
  ];

  postInstall = ''
    # We do not have central location to install typelibs to,
    # let’s ensure GNOME Shell can still find them.
    extensionDir="$out/share/gnome-shell/extensions/GPaste@gnome-shell-extensions.gnome.org"
    mv "$extensionDir/"{extension,.extension-wrapped}.js
    mv "$extensionDir/"{prefs,.prefs-wrapped}.js
    substitute "${./wrapper.js}" "$extensionDir/extension.js" \
      --subst-var-by originalName "extension" \
      --subst-var-by typelibPath "${placeholder "out"}/lib/girepository-1.0"
    substitute "${./wrapper.js}" "$extensionDir/prefs.js" \
      --subst-var-by originalName "prefs" \
      --subst-var-by typelibPath "${placeholder "out"}/lib/girepository-1.0"
  '';

  meta = with lib; {
    homepage = "https://github.com/Keruspe/GPaste";
    description = "Clipboard management system with GNOME 3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
