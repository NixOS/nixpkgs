{ stdenv, fetchurl, vala, libxslt, pkgconfig, glib, dbus-glib, gnome3
, libxml2, intltool, docbook_xsl_ns, docbook_xsl, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "dconf-editor-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/dconf-editor/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0nhcpwqrkmpxbhaf0cafvy6dlp6s7vhm5vknl4lgs3l24zc56ns5";
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
