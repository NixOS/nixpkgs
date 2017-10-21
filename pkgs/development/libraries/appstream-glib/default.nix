{ stdenv, fetchFromGitHub, pkgconfig, gettext, gtk3, intltool, glib
, gtk_doc, autoconf, automake, libtool, libarchive
, gobjectIntrospection, sqlite, libsoup, gcab, attr, acl, docbook_xsl
, libuuid, json_glib, autoconf-archive, meson, gperf, ninja, gdk_pixbuf
}:
let rpath = stdenv.lib.makeLibraryPath
      [ libuuid.out
        glib
        libsoup
        gdk_pixbuf
        libarchive.lib
        gcab
      ];
in stdenv.mkDerivation rec {
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

  postFixup = ''
    for elf in "$out"/bin/* "$out"/lib/*.so; do
      patchelf --set-rpath '${rpath}':"$out/lib" "$elf"
    done
  '';

  meta = with stdenv.lib; {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage    = https://github.com/hughsie/appstream-glib;
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ lethalman matthewbauer ];
  };
}
