{ fetchurl, stdenv, substituteAll, pkgconfig, gnome3, ibus, intltool, upower, wrapGAppsHook
, libcanberra-gtk3, accountsservice, libpwquality, libpulseaudio
, gdk_pixbuf, librsvg, libnotify, libgudev, gnome-color-manager
, libxml2, polkit, libxslt, libgtop, libsoup, colord, colord-gtk
, cracklib, libkrb5, networkmanagerapplet, networkmanager, glibc
, libwacom, samba, shared-mime-info, tzdata, libtool, libgnomekbd
, docbook_xsl, docbook_xsl_ns, modemmanager, clutter, clutter-gtk
, fontconfig, sound-theme-freedesktop, grilo }:

let
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "gnome-control-center-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-control-center/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0nyx5nl2rky0249rdcy0hsccnxf3angpya0q859rrbrwaixqnxh3";
  };

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

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gcm = gnome-color-manager;
      inherit glibc libgnomekbd tzdata;
    })
  ];

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

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-control-center";
      attrPath = "gnome3.gnome-control-center";
    };
  };

  meta = with stdenv.lib; {
    description = "Utilities to configure the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
