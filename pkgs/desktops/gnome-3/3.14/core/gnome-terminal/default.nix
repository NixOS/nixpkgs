{ stdenv, fetchurl, pkgconfig, cairo, libxml2, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, libuuid, vala
, desktop_file_utils, itstool, makeWrapper, appdata-tools }:

stdenv.mkDerivation rec {

  versionMajor = gnome3.version;
  versionMinor = "2";

  name = "gnome-terminal-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${versionMajor}/${name}.tar.xz";
    sha256 = "886bf9accb863d59791c5d8f2078d0fb022245a79854ad4a131b7b2186c27d2b";
  };

  buildInputs = [ gnome3.gtk gnome3.gsettings_desktop_schemas gnome3.vte appdata-tools
                  gnome3.dconf itstool makeWrapper gnome3.nautilus vala ];

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
    maintainers = [ maintainers.lethalman ];
  };
}
