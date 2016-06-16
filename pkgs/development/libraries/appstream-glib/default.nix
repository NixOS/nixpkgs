{ stdenv, fetchFromGitHub, pkgconfig, gettext, gtk3, intltool, glib
, gtk_doc, autoconf, automake, libtool, libarchive, libyaml
, gobjectIntrospection, sqlite, libsoup, gcab, attr, acl, docbook_xsl
, libuuid, json_glib
}:

stdenv.mkDerivation rec {
  name = "appstream-glib-0.5.11";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    rev = stdenv.lib.replaceStrings ["." "-"] ["_" "_"] name;
    sha256 = "1rvfncm9z29h70pd718j73cd263g6yyxkxrg7zfzy0gj6wwzvhkh";
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
