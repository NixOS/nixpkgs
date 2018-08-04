{ stdenv, fetchurl, autoreconfHook, pkgconfig, vala, glib, gjs, mutter
, pango, gtk3, gnome3, dbus, clutter, appstream-glib, wrapGAppsHook, systemd, gobjectIntrospection }:

stdenv.mkDerivation rec {
  version = "3.28.2";
  name = "gpaste-${version}";

  src = fetchurl {
    url = "https://github.com/Keruspe/GPaste/archive/v${version}.tar.gz";
    sha256 = "1zfx73qpw976hyzp5k569lywsq2b6dbnnzf2cvhjvn3mvkw8pin2";
  };

  patches = [
    ./fix-paths.patch
  ];

  # TODO: switch to substituteAll with placeholder
  # https://github.com/NixOS/nix/issues/1846
  # https://github.com/NixOS/nixpkgs/pull/37693
  postPatch = ''
    substituteInPlace src/gnome-shell/extension.js \
      --subst-var-by typelibPath "$out/lib/girepository-1.0"
    substituteInPlace src/gnome-shell/prefs.js \
      --subst-var-by typelibPath "$out/lib/girepository-1.0"
    substituteInPlace src/libgpaste/settings/gpaste-settings.c \
      --subst-var-by gschemasCompiled "$out/share/gsettings-schemas/${name}/glib-2.0/schemas"
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig vala wrapGAppsHook ];
  buildInputs = [ glib gjs mutter gnome3.adwaita-icon-theme
                  gtk3 gnome3.gnome-control-center dbus
                  clutter pango appstream-glib systemd gobjectIntrospection ];

  configureFlags = [ "--with-controlcenterdir=$(out)/share/gnome-control-center/keybindings"
                     "--with-dbusservicesdir=$(out)/share/dbus-1/services"
                     "--with-systemduserunitdir=$(out)/etc/systemd/user" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/Keruspe/GPaste;
    description = "Clipboard management system with GNOME3 integration";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
