{ stdenv, fetchurl, pkgconfig, cairo, libxml2, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, gconf, libuuid
, desktop_file_utils, itstool, ncurses, makeWrapper }:

stdenv.mkDerivation rec {

  versionMajor = "3.10";
  versionMinor = "2";

  name = "gnome-terminal-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${versionMajor}/${name}.tar.xz";
    sha256 = "04yrk9531f373nl64jx3pczsnq7a56mj3n436jbhjp74kp12fa70";
  };

  buildInputs = [ gnome3.gtk gnome3.gsettings_desktop_schemas gnome3.vte
                  gnome3.dconf gnome3.gconf itstool ncurses makeWrapper ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which libuuid libxml2 desktop_file_utils ];

  preFixup = ''
    for f in "$out/libexec/gnome-terminal-migration" "$out/libexec/gnome-terminal-server"; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
