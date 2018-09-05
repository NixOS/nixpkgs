{ fetchurl, stdenv, pkgconfig, gnome3, intltool, gobjectIntrospection, upower, cairo
, pango, cogl, clutter, libstartup_notification, zenity, libcanberra-gtk3
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon, libXtst, libinput
, pipewire, libgudev, libwacom, xwayland, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "mutter-${version}";
  version = "3.30.1";

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "094w1kfr7z5c34d1rhq1dncb7ln403n89s8x5xihac7zldlrjldm";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "mutter"; attrPath = "gnome3.mutter"; };
  };

  configureFlags = [
    "--with-x"
    "--disable-static"
    # "--enable-remote-desktop"
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
    glib gobjectIntrospection gtk gsettings-desktop-schemas upower
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
