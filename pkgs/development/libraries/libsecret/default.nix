{ stdenv, fetchurl, glib, dbus_libs, unzip, automake, libtool, autoconf, m4, docbook_xsl,
  intltool, gtk_doc, gobjectIntrospection, pkgconfig, libxslt, libgcrypt }:

stdenv.mkDerivation rec {
  version = "0.16";
  name = "libsecret-${version}";

  src = fetchurl {
    url = "https://git.gnome.org/browse/libsecret/snapshot/libsecret-${version}.zip";
    sha256 = "1yf4zvzfa45wr5bqlh54g3bmd0lgcsa8hnhppa99czca0zj7bkks";
  };

  propagatedBuildInputs = [ glib dbus_libs ];
  nativeBuildInputs = [ unzip ];
  buildInputs = [ gtk_doc automake libtool autoconf intltool gobjectIntrospection pkgconfig libxslt libgcrypt m4 docbook_xsl ];

  configureScript = "./autogen.sh";

  meta = {
    inherit (glib.meta) platforms maintainers;
  };
}
