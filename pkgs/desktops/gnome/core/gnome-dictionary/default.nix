{ lib, stdenv, fetchurl, meson, ninja, pkg-config, desktop-file-utils, appstream-glib, libxslt
, libxml2, gettext, itstool, wrapGAppsHook, docbook_xsl, docbook_xml_dtd_43
, gnome, gtk3, glib, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "gnome-dictionary";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-dictionary/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1d8dhcfys788vv27v34i3s3x3jdvdi2kqn2a5p8c937a9hm0qr9f";
  };

  doCheck = true;

  nativeBuildInputs = [
    meson ninja pkg-config wrapGAppsHook libxml2 gettext itstool
    desktop-file-utils appstream-glib libxslt docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ gtk3 glib gsettings-desktop-schemas gnome.adwaita-icon-theme ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-dictionary";
      attrPath = "gnome.gnome-dictionary";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Dictionary";
    description = "Dictionary is the GNOME application to look up definitions";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
