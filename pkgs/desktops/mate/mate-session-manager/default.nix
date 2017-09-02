{ stdenv, fetchurl, pkgconfig, intltool, itstool, dbus_glib, systemd, xtrans, xorg, gnome3, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-session-manager-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "0i0xq6041x2qmb26x9bawx0qpfkgjn6x9w3phnm9s7rc4s0z20ll";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    dbus_glib
    systemd
    xtrans
    xorg.libSM
    gnome3.gtk3
    gnome3.gsettings_desktop_schemas
    mate.mate-desktop
  ];

  meta = with stdenv.lib; {
    description = "MATE Desktop session manager";
    homepage = https://github.com/mate-desktop/mate-session-manager;
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
