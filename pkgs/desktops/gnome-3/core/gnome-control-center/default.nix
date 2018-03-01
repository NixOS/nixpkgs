{ fetchurl, stdenv, pkgconfig, gnome3, ibus, intltool, upower, wrapGAppsHook
, libcanberra-gtk3, accountsservice, libpwquality, libpulseaudio
, gdk_pixbuf, librsvg, libnotify, libgudev
, libxml2, polkit, libxslt, libgtop, libsoup, colord, colord-gtk
, cracklib, libkrb5, networkmanagerapplet, networkmanager
, libwacom, samba, shared-mime-info, tzdata, libtool
, docbook_xsl, docbook_xsl_ns, modemmanager, clutter, clutter-gtk
, fontconfig, sound-theme-freedesktop, grilo }:

stdenv.mkDerivation rec {
  name = "gnome-control-center-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-control-center/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "07aed27d6317f2cad137daa6d94a37ad02c32b958dcd30c8f07d0319abfb04c5";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-control-center"; attrPath = "gnome3.gnome-control-center"; };
  };

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [
    pkgconfig intltool wrapGAppsHook libtool libxslt docbook_xsl docbook_xsl_ns
    shared-mime-info
  ];

  buildInputs = with gnome3; [
    ibus gtk glib glib-networking upower gsettings-desktop-schemas
    libxml2 gnome-desktop gnome-settings-daemon polkit libgtop
    gnome-online-accounts libsoup colord libpulseaudio fontconfig colord-gtk
    accountsservice libkrb5 networkmanagerapplet libwacom samba libnotify
    grilo libpwquality cracklib vino libcanberra-gtk3 libgudev
    gdk_pixbuf defaultIconTheme librsvg clutter clutter-gtk
    networkmanager modemmanager gnome-bluetooth tracker
  ];

  preBuild = ''
    substituteInPlace panels/datetime/tz.h --replace "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"

    substituteInPlace panels/region/cc-region-panel.c --replace "gkbd-keyboard-display" "${gnome3.libgnomekbd}/bin/gkbd-keyboard-display"

    # hack to make test-endianess happy
    mkdir -p $out/share/locale
    substituteInPlace panels/datetime/test-endianess.c --replace "/usr/share/locale/" "$out/share/locale/"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome3.gnome-themes-standard}/share:${sound-theme-freedesktop}/share"
      # Thumbnailers (for setting user profile pictures)
      --prefix XDG_DATA_DIRS : "${gdk_pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
    )
    for i in $out/share/applications/*; do
      substituteInPlace $i --replace "gnome-control-center" "$out/bin/gnome-control-center"
    done
  '';

  meta = with stdenv.lib; {
    description = "Utilities to configure the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
