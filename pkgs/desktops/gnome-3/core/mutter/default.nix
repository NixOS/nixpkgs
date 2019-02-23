{ fetchurl, fetchpatch, stdenv, pkgconfig, gnome3, intltool, gobject-introspection, upower, cairo
, pango, cogl, clutter, libstartup_notification, zenity, libcanberra-gtk3
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon, libXtst, libinput
, pipewire, libgudev, libwacom, xwayland, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "mutter-${version}";
  version = "3.30.2";

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0qr3w480p31nbiad49213rj9rk6p9fl82a68pzznpz36p30dq96z";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "mutter"; attrPath = "gnome3.mutter"; };
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/mutter/issues/270
    # Fixes direction of the desktop switching animation when using workspace
    # grid extension with desktops arranged horizontally.
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/mutter/commit/92cccf53dfe9e077f1d61ac4f896fd391f8cb689.patch;
      sha256 = "11vmypypjss50xg7hhdbqrxvgqlxx4lnwy59089qsfl3akg4kk2i";
    })
  ];


  configureFlags = [
    "--with-x"
    "--disable-static"
    "--enable-remote-desktop"
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

  buildInputs = with gnome3; [
    glib gobject-introspection gtk gsettings-desktop-schemas upower
    gnome-desktop cairo pango cogl clutter zenity libstartup_notification
    gnome3.geocode-glib libinput libgudev libwacom
    libcanberra-gtk3 zenity xkeyboard_config libxkbfile
    libxkbcommon pipewire
  ];

  preFixup = ''
    wrapProgram "$out/bin/mutter" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
  };
}
