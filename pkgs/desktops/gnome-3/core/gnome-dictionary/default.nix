{ stdenv, fetchurl, meson, ninja, pkgconfig, desktop-file-utils, appstream-glib, libxslt
, libxml2, gettext, itstool, wrapGAppsHook, docbook_xsl, docbook_xml_dtd_43
, gnome3, gtk3, glib, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "gnome-dictionary-${version}";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-dictionary/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "16b8bc248dcf68987826d5e39234b1bb7fd24a2607fcdbf4258fde88f012f300";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson ninja pkgconfig wrapGAppsHook libxml2 gettext itstool
    desktop-file-utils appstream-glib libxslt docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ gtk3 glib gsettings-desktop-schemas gnome3.adwaita-icon-theme ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-dictionary";
      attrPath = "gnome3.gnome-dictionary";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Dictionary;
    description = "Dictionary is the GNOME application to look up definitions";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
