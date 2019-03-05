{ stdenv, fetchurl, autoreconfHook, pkgconfig, vala, glib, gjs, mutter, fetchpatch
, pango, gtk3, gnome3, dbus, clutter, appstream-glib, wrapGAppsHook, systemd, gobject-introspection }:

stdenv.mkDerivation rec {
  version = "3.30.2";
  name = "gpaste-${version}";

  src = fetchurl {
    url = "https://github.com/Keruspe/GPaste/archive/v${version}.tar.gz";
    sha256 = "0vlbvv6rjxq7h9cl3ilndjk7d51ac1x7agj8k6a7bwjx8h1fr62x";
  };

  patches = [
    ./fix-paths.patch
    (fetchpatch {
      url = https://github.com/Keruspe/GPaste/commit/eacd9ecbcf6db260a2bdc22275c7a855cad66424.patch;
      sha256 = "1668xcmx90gpjlgv2iyp6yqbxq3r5sw5cxds0dmzlyvbqdmc3py2";
    })
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
