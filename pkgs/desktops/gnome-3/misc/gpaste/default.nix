{ stdenv
, fetchFromGitHub
, fetchpatch
, appstream-glib
, clutter
, gjs
, glib
, gobject-introspection
, gtk3
, meson
, mutter
, ninja
, pango
, pkgconfig
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "3.38.3";
  pname = "gpaste";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "GPaste";
    rev = "v${version}";
    sha256 = "10ag0mrr4r40414nyarghpgjawvf331asxgq47dqjfxr5w7bz6wc";
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
    substituteInPlace src/libgpaste/settings/gpaste-settings.c \
      --subst-var-by gschemasCompiled ${glib.makeSchemaPath (placeholder "out") "${pname}-${version}"}
  '';

  nativeBuildInputs = [
    appstream-glib
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter # required by mutter-clutter
    gjs
    glib
    gtk3
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/Keruspe/GPaste";
    description = "Clipboard management system with GNOME 3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
