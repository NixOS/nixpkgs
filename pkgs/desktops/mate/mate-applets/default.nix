{ stdenv, fetchurl, pkgconfig, intltool, itstool, gnome3, glib, gtk3, gtksourceview3, libwnck3, libgtop, libxml2, libnotify, polkit, upower, wirelesstools, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-applets";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1c32rkkry6kka2arrx5psjj037j79icp5jr1s0qh596dvsgxciqc";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gtksourceview3
    gnome3.gucharmap
    libwnck3
    libgtop
    libxml2
    libnotify
    polkit
    upower
    wirelesstools
    mate.libmateweather
    mate.mate-panel
    hicolor-icon-theme
  ];

  configureFlags = [ "--enable-suid=no" ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  meta = with stdenv.lib; {
    description = "Applets for use with the MATE panel";
    homepage = https://mate-desktop.org;
    license = with licenses; [ gpl2Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
