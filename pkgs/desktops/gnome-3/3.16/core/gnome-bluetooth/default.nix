{ stdenv, fetchurl, gnome3, pkgconfig, intltool, glib
, udev, itstool, libxml2, makeWrapper }:

stdenv.mkDerivation rec {
  name = "gnome-bluetooth-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-bluetooth/${gnome3.version}/${name}.tar.xz";
    sha256 = "12z0792j5ln238ajhgqx5jrm34wz2yqbbskhlp23p9c0cwnj1srz";
  };

  buildInputs = with gnome3; [ pkgconfig intltool glib gtk3 udev libxml2 gnome3.defaultIconTheme
                               makeWrapper gsettings_desktop_schemas itstool ];

  preFixup = ''
    wrapProgram "$out/bin/bluetooth-sendto" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://help.gnome.org/users/gnome-bluetooth/stable/index.html.en;
    description = "Application that let you manage Bluetooth in the GNOME destkop";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
