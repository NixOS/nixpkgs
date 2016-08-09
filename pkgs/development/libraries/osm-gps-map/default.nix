{ cairo, fetchzip, glib, gnome3, gobjectIntrospection, pkgconfig, stdenv }:

stdenv.mkDerivation rec {
  name = "osm-gps-map-${version}";
  version = "1.1.0";

  src = fetchzip {
    url = "https://github.com/nzjrs/osm-gps-map/releases/download/${version}/osm-gps-map-${version}.tar.gz";
    sha256 = "0fal3mqcf3yypir4f7njz0dm5wr7lqwpimjx28wz9imh48cqx9n9";
  };

  outputs = [ "dev" "out" "doc" ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    cairo glib gobjectIntrospection
  ] ++ (with gnome3; [
    gnome_common gtk libsoup
  ]);

  meta = with stdenv.lib; {
    description = "Gtk+ widget for displaying OpenStreetMap tiles";
    homepage = https://nzjrs.github.io/osm-gps-map;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ hrdinka ];
    platforms = platforms.linux;
  };
}
