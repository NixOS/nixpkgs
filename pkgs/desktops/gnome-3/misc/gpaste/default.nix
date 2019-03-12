{ stdenv, fetchurl, autoreconfHook, pkgconfig, vala, glib, gjs, mutter, fetchpatch
, pango, gtk3, gnome3, dbus, clutter, appstream-glib, wrapGAppsHook, systemd, gobject-introspection }:

stdenv.mkDerivation rec {
  version = "3.32.0";
  name = "gpaste-${version}";

  src = fetchurl {
    url = "https://github.com/Keruspe/GPaste/archive/v${version}.tar.gz";
    sha256 = "1fvpl9vqmrr1w22hm0ybabn9pjfii5qj9ghnc2jzihgrn2h486v6";
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
      --subst-var-by gschemasCompiled "${placeholder "out"}/share/gsettings-schemas/${name}/glib-2.0/schemas"
  '';

  nativeBuildInputs = [
    autoreconfHook pkgconfig vala appstream-glib wrapGAppsHook
  ];
  buildInputs = [
    glib gjs mutter gtk3 dbus
    clutter pango gobject-introspection
  ];

  configureFlags = [
    "--with-controlcenterdir=${placeholder "out"}/share/gnome-control-center/keybindings"
    "--with-dbusservicesdir=${placeholder "out"}/share/dbus-1/services"
    "--with-systemduserunitdir=${placeholder "out"}/etc/systemd/user"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/Keruspe/GPaste;
    description = "Clipboard management system with GNOME3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
