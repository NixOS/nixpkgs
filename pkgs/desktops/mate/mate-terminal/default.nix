{ stdenv, fetchurl, pkgconfig, intltool, glib, itstool, libxml2, mate, gnome3, gtk3, vte, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-terminal-${version}";
  version = "1.22.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "08210ry5lrivsgzqpdaxrchhpj0n5s1q0x4pxmwdpnksjpcj11mn";
  };

  buildInputs = [
     glib
     itstool
     libxml2

     mate.mate-desktop

     vte
     gtk3
     gnome3.dconf
  ];

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  meta = with stdenv.lib; {
    description = "The MATE Terminal Emulator";
    homepage = https://mate-desktop.org;
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
