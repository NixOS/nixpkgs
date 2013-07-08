{ stdenv, fetchurl, glib, dbus_libs, unzip, automake, libtool, autoconf, m4, docbook_xsl,
  intltool, gtk_doc, gobjectIntrospection, pkgconfig, libxslt, libgcrypt }:

stdenv.mkDerivation rec {
  version = "0.15";
  name = "libsecret-${version}";

  src = fetchurl {
    url = "https://git.gnome.org/browse/libsecret/snapshot/libsecret-${version}.zip";
    sha256 = "088v1z7zbdi8b0779jads7q20x1gx6c4zmrj3q0vysc7a0k16i6k";
  };

  propagatedBuildInputs = [ glib dbus_libs ];
  nativeBuildInputs = [ unzip ];
  buildInputs = [ gtk_doc automake libtool autoconf intltool gobjectIntrospection pkgconfig libxslt libgcrypt m4 docbook_xsl ];

  configureScript = "./autogen.sh";

  meta = {
    inherit (glib.meta) platforms maintainers;
  };
}
