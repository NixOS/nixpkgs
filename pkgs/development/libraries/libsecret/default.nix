{ stdenv, fetchurl, glib, dbus_libs, unzip, docbook_xsl
, intltool, gtk_doc, gobjectIntrospection, pkgconfig, libxslt, libgcrypt
}:

stdenv.mkDerivation rec {
  version = "0.18";
  name = "libsecret-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libsecret/${version}/${name}.tar.xz";
    sha256 = "1qq29c01xxjyx5sl6y5h22w8r0ff4c73bph3gfx3h7mx5mvalwqc";
  };

  propagatedBuildInputs = [ glib dbus_libs ];
  nativeBuildInputs = [ unzip ];
  buildInputs = [ gtk_doc intltool gobjectIntrospection pkgconfig libxslt libgcrypt docbook_xsl ];

  meta = {
    inherit (glib.meta) platforms maintainers;
  };
}
