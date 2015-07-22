{ stdenv, fetchurl, pkgconfig, gettext, gtk3, intltool, glib
, gtk_doc, autoconf, automake, libtool, libarchive, libyaml
, gobjectIntrospection, sqlite, libsoup, gcab, attr, acl, docbook_xsl
}:

stdenv.mkDerivation rec {
  name = "appstream-glib-0.3.6";

  src = fetchurl {
    url = "https://github.com/hughsie/appstream-glib/archive/appstream_glib_0_3_6.tar.gz";
    sha256 = "1zdxg9dk9vxw2cs04cswd138di3dysz0hxk4918750hh19s3859c";
  };

  buildInputs = [ glib libtool pkgconfig gtk_doc gettext intltool sqlite libsoup
                  gcab attr acl docbook_xsl
                  libarchive libyaml gtk3 autoconf automake gobjectIntrospection ];

  configureScript = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage    = https://github.com/hughsie/appstream-glib;
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ lethalman ];
  };

}
