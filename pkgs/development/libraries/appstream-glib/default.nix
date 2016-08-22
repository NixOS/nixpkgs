{ stdenv, fetchFromGitHub, pkgconfig, gettext, gtk3, intltool, glib
, gtk_doc, autoconf, automake, libtool, libarchive, libyaml
, gobjectIntrospection, sqlite, libsoup, gcab, attr, acl, docbook_xsl
, libuuid, json_glib
}:

stdenv.mkDerivation rec {
  name = "appstream-glib-0.5.12";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    rev = stdenv.lib.replaceStrings ["." "-"] ["_" "_"] name;
    sha256 = "00b0441f409vzgy0znn42k093w7hwv3495qvsakxnhvk1h1ws23s";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig intltool ];
  buildInputs = [ glib gtk_doc gettext sqlite libsoup
                  gcab attr acl docbook_xsl libuuid json_glib
                  libarchive libyaml gtk3 gobjectIntrospection ];

  configureScript = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage    = https://github.com/hughsie/appstream-glib;
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ lethalman matthewbauer ];
  };
}
