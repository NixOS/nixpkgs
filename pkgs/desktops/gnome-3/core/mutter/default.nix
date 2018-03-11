{ fetchurl, stdenv, pkgconfig, gnome3, intltool, gobjectIntrospection, upower, cairo
, pango, cogl, clutter, libstartup_notification, zenity, libcanberra-gtk3
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon, libXtst, libinput
, pipewire, libgudev, libwacom, xwayland, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "mutter-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/mutter/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "83309feb05a4635c47713665c0592af8ab6d7f17a36e4bd626d67609b6422fab";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "mutter"; attrPath = "gnome3.mutter"; };
  };

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

  patches = [
    # Pipewire 0.1.8 compatibility
    (fetchurl {
      name = "mutter-pipewire-0.1.8-compat.patch";
      url = https://bugzilla.gnome.org/attachment.cgi?id=367356;
      sha256 = "10bx5zf11wwhhy686w11ggikk56pbxydpbk9fbd947ir385x92cz";
    })
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
