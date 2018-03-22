{ stdenv, fetchurl, meson, ninja, pkgconfig, desktop-file-utils, appstream-glib, libxslt
, libxml2, gettext, itstool, wrapGAppsHook, docbook_xsl, docbook_xml_dtd_43
, gnome3, gtk, glib }:

stdenv.mkDerivation rec {
  name = "gnome-dictionary-${version}";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-dictionary/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "16b8bc248dcf68987826d5e39234b1bb7fd24a2607fcdbf4258fde88f012f300";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-dictionary"; attrPath = "gnome3.gnome-dictionary"; };
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];
  propagatedBuildInputs = [ gnome3.defaultIconTheme ];

  nativeBuildInputs = [ meson ninja pkgconfig wrapGAppsHook libxml2 gettext itstool
                        desktop-file-utils appstream-glib libxslt docbook_xsl docbook_xml_dtd_43];
  buildInputs = [ gtk glib gnome3.gsettings-desktop-schemas ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Dictionary;
    description = "Dictionary is the GNOME application to look up definitions";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
