{ stdenv, fetchurl, vala, libxslt, pkgconfig, glib, dbus-glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "dconf-editor-${version}";
  version = "3.26.2";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf-editor/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "28b453fe49c49d7dfaf07c85c01d7495913f93ab64a0b223c117eb17d1cb8ad1";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "dconf-editor"; attrPath = "gnome3.dconf-editor"; };
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = [ vala libxslt glib dbus-glib gnome3.gtk libxml2 gnome3.defaultIconTheme
                  intltool docbook_xsl docbook_xsl_ns gnome3.dconf ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
