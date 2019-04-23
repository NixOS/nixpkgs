{ fetchFromGitLab, stdenv, substituteAll, pkgconfig, gnome3, intltool, gobject-introspection, upower, cairo
, glib, gtk3, pango, cogl, clutter, libstartup_notification, zenity, libcanberra-gtk3
, gsettings-desktop-schemas, gnome-desktop, wrapGAppsHook
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon, libXtst, libinput
, geocode-glib, libgudev, libwacom, xwayland, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mutter";
  version = "3.28.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "4af8d9d4752a94612a98d619e65828f0070a7b0e"; # HEAD of https://gitlab.gnome.org/GNOME/mutter/tree/gnome-3-28
    sha256 = "1rmc1bf80yq776xhygi1jzgia1y44j2mr2n94vlxgzqc0whamx2v";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths-328.patch;
      inherit zenity;
    })
  ];

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
    "--enable-compile-warnings=maximum"
  ];

  propagatedBuildInputs = [
    # required for pkgconfig to detect mutter-clutter
    libXtst
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig intltool libtool wrapGAppsHook ];

  buildInputs = [
    glib gobject-introspection gtk3 gsettings-desktop-schemas upower
    gnome-desktop cairo pango cogl clutter zenity libstartup_notification
    geocode-glib libinput libgudev libwacom
    libcanberra-gtk3 zenity xkeyboard_config libxkbfile
    libxkbcommon
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
  };
}
