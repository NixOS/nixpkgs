{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, gettext, itstool, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_43, systemd }:

stdenv.mkDerivation rec {
  name = "gnome-logs-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0j3wkbz7c2snmx4kjmh767175nf2lqxx2p8b8xa2qslknxc3gq6b";
  };

  configureFlags = [ "--disable-tests" ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook gettext itstool libxml2 libxslt docbook_xsl docbook_xml_dtd_43 ];
  buildInputs = [ gtk3 systemd gnome3.gsettings-desktop-schemas gnome3.defaultIconTheme ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-logs";
      attrPath = "gnome3.gnome-logs";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Logs;
    description = "A log viewer for the systemd journal";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
