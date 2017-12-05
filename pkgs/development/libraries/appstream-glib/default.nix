{ stdenv, fetchFromGitHub, pkgconfig, gettext, gtk3, glib
, gtk_doc, libarchive, gobjectIntrospection
, sqlite, libsoup, gcab, attr, acl, docbook_xsl
, libuuid, json_glib, meson, gperf, ninja
}:
stdenv.mkDerivation rec {
  name = "appstream-glib-0.7.2";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    rev = stdenv.lib.replaceStrings ["." "-"] ["_" "_"] name;
    sha256 = "1jvwfida12d2snc8p9lpbpqzrixw2naaiwfmsrldwkrxsj3i19pl";
  };

  nativeBuildInputs = [ meson pkgconfig ninja ];
  buildInputs = [ glib gtk_doc gettext sqlite libsoup
                  gcab attr acl docbook_xsl libuuid json_glib
                  libarchive gobjectIntrospection gperf ];
  propagatedBuildInputs = [ gtk3 ];
  mesonFlags = [ "-Denable-rpm=false" "-Denable-stemmer=false" "-Denable-dep11=false" ];

  meta = with stdenv.lib; {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage    = https://github.com/hughsie/appstream-glib;
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ lethalman matthewbauer ];
  };
}
