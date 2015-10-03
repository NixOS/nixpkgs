{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-mahjongg-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${gnome3.version}/${name}.tar.xz";
    sha256 = "1jbd3gbmxqf36as9xsiarad575l4rpcfv6w1pn192r02aj3hgipj";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook librsvg intltool itstool libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Mahjongg;
    description = "Disassemble a pile of tiles by removing matching pairs";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
