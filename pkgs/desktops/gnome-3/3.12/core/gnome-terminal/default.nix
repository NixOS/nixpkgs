{ stdenv, fetchurl, pkgconfig, cairo, libxml2, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, libuuid
, desktop_file_utils, itstool, makeWrapper, appdata-tools }:

stdenv.mkDerivation rec {

  versionMajor = "3.12";
  versionMinor = "2";

  name = "gnome-terminal-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${versionMajor}/${name}.tar.xz";
    sha256 = "ea19ce610af2873d26e1e75491415e17af6a5080366db966f9220fdeea5ebecd";
  };

  buildInputs = [ gnome3.gtk gnome3.gsettings_desktop_schemas gnome3.vte appdata-tools
                  gnome3.dconf itstool makeWrapper gnome3.nautilus ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which libuuid libxml2 desktop_file_utils ];

  # FIXME: enable for gnome3
  configureFlags = [ "--disable-search-provider" "--disable-migration" ];

  preFixup = ''
    for f in "$out/libexec/gnome-terminal-server"; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
