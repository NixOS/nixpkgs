{ stdenv, fetchurl, autoconf, pkgconfig, glib, gobjectIntrospection, gnome3
, webkitgtk, libsoup, libxml2, libarchive }:
stdenv.mkDerivation rec {
  name = "libgepub-${version}";
  version = "0.4";

  src = fetchurl {
    url = "mirror://gnome/sources/libgepub/${version}/${name}.tar.xz";
    sha256 = "5666a1c4d186d205bd2d91b71d4c1cd5426025569114a765dd913a564f149ff4";
  };

  doCheck = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf glib gobjectIntrospection webkitgtk libsoup
    libxml2 libarchive ];

  meta = with stdenv.lib; {
    description = "GObject based library for handling and rendering epub documents";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
