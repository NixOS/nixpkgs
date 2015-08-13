{ stdenv, fetchurl, pkgconfig, intltool, gtk3, gnome3, wrapGAppsHook
, json_glib, qqwing, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "gnome-sudoku-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-sudoku/${gnome3.version}/${name}.tar.xz";
    sha256 = "1b9xwldzjjpkwb2na9cbs8z4gv8dlj9dm574gybdz466190lrsxv";
  };

  buildInputs = [ pkgconfig intltool wrapGAppsHook gtk3 gnome3.libgee
                  json_glib qqwing itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Sudoku;
    description = "Test your logic skills in this number grid puzzle";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
