{ fetchurl, fetchpatch, stdenv, pkgconfig, gnome3, intltool, gobjectIntrospection, upower, cairo
, pango, cogl, clutter, libstartup_notification, libcanberra_gtk2, zenity, libcanberra_gtk3
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon, libXtst, libudev, libinput
, libgudev, libwacom, xwayland, autoreconfHook }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # fatal error: gio/gunixfdlist.h: No such file or directory
  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0 -Wno-error=format -Wno-error=sign-compare";

  configureFlags = [
    "--with-x"
    "--disable-static"
    "--enable-shape"
    "--enable-sm"
    "--enable-startup-notification"
    "--enable-xsync"
    "--enable-verbose-mode"
    "--with-libcanberra"
    "--with-xwayland-path=${xwayland}/bin/Xwayland"
  ];

  propagatedBuildInputs = [
    # required for pkgconfig to detect mutter-clutter
    libXtst
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig intltool libtool makeWrapper ];

  buildInputs = with gnome3;
    [ glib gobjectIntrospection gtk gsettings_desktop_schemas upower
      gnome_desktop cairo pango cogl clutter zenity libstartup_notification libcanberra_gtk2
      gnome3.geocode_glib libudev libinput libgudev libwacom
      libcanberra_gtk3 zenity xkeyboard_config libxkbfile
      libxkbcommon ];

  patches = [
    # https://bugzilla.gnome.org/show_bug.cgi?id=760670
    (fetchpatch {
      name = "libgudev-232.patch";
      url = https://bugzilla.gnome.org/attachment.cgi?id=358904;
      sha256 = "0chvd7g9f2zp3a0gdhvinsfvp2h10rwb6a8ja386vsrl93ac8pix";
    })
  ];

  preFixup = ''
    wrapProgram "$out/bin/mutter" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
