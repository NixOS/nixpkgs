{ stdenv, fetchurl, gnome3, pkgconfig, intltool, glib
, udev, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-bluetooth-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-bluetooth/${gnome3.version}/${name}.tar.xz";
    sha256 = "0rsw27yj6887axk7s2vwpsr0pmic0wdskl7sx8rk4kns7b0ifs88";
  };

  buildInputs = with gnome3; [ pkgconfig intltool glib gtk3 udev libxml2
                               gsettings_desktop_schemas itstool ];

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-bluetooth/stable/index.html.en;
    description = "Application that let you manage Bluetooth in the GNOME destkop";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
