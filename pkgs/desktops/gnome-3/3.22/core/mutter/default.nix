{ fetchurl, stdenv, pkgconfig, gnome3, intltool, gobjectIntrospection, upower, cairo
, pango, cogl, clutter, libstartup_notification, libcanberra_gtk2, zenity, libcanberra_gtk3
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon, libudev, libinput
, libgudev, xwayland }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # fatal error: gio/gunixfdlist.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0 -Wno-error=format -Wno-error=sign-compare";

  configureFlags = "--with-x --disable-static --enable-shape --enable-sm --enable-startup-notification --enable-xsync --enable-verbose-mode --with-libcanberra --with-xwayland-path=${xwayland}/bin/Xwayland";

  buildInputs = with gnome3;
    [ pkgconfig intltool glib gobjectIntrospection gtk gsettings_desktop_schemas upower
      gnome_desktop cairo pango cogl clutter zenity libstartup_notification libcanberra_gtk2
      gnome3.geocode_glib libudev libinput libgudev
      libcanberra_gtk3 zenity libtool makeWrapper xkeyboard_config libxkbfile libxkbcommon ];

  preFixup = ''
    wrapProgram "$out/bin/mutter" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  patches = [
    ./x86.patch # ./math.patch
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
