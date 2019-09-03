{ cairo, fetchzip, glib, gnome3, gtk3, gobject-introspection, pkgconfig, stdenv }:

stdenv.mkDerivation rec {
  pname = "osm-gps-map";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/nzjrs/osm-gps-map/releases/download/${version}/osm-gps-map-${version}.tar.gz";
    sha256 = "0fal3mqcf3yypir4f7njz0dm5wr7lqwpimjx28wz9imh48cqx9n9";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    cairo glib gobject-introspection
    gnome3.gnome-common gtk3 gnome3.libsoup
  ];

  meta = with stdenv.lib; {
    description = "Gtk+ widget for displaying OpenStreetMap tiles";
    homepage = https://nzjrs.github.io/osm-gps-map;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
