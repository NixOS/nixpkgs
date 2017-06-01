{ stdenv, fetchFromGitHub, pkgconfig, gettext, gtk3, intltool, glib
, gtk_doc, autoconf, automake, libtool, libarchive, libyaml
, gobjectIntrospection, sqlite, libsoup, gcab, attr, acl, docbook_xsl
, libuuid, json_glib, autoconf-archive
}:

stdenv.mkDerivation rec {
  name = "appstream-glib-0.6.3";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    rev = stdenv.lib.replaceStrings ["." "-"] ["_" "_"] name;
    sha256 = "12l0vzhi9vpyrnf7vrpq21rb26mb6yskp5zgngdjyjanwhzmc617";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig intltool autoconf-archive ];
  buildInputs = [ glib gtk_doc gettext sqlite libsoup
                  gcab attr acl docbook_xsl libuuid json_glib
                  libarchive libyaml gobjectIntrospection ];
  propagatedBuildInputs = [ gtk3 ];
  configureScript = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage    = https://github.com/hughsie/appstream-glib;
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ lethalman matthewbauer ];
  };
}
