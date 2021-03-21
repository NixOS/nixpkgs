{ lib, stdenv, fetchurl, fetchpatch, meson, ninja, pkg-config, desktop-file-utils, appstream-glib, libxslt
, libxml2, gettext, itstool, wrapGAppsHook, docbook_xsl, docbook_xml_dtd_43
, gnome3, gtk3, glib, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "gnome-dictionary";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-dictionary/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "1d8dhcfys788vv27v34i3s3x3jdvdi2kqn2a5p8c937a9hm0qr9f";
  };

  patches = [
    # fix AppStream validation
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-dictionary/commit/1c94d612030ef87c6e26a01a490470b71c39e341.patch";
      sha256 = "0cbswmhs9mks3gsc0iy4wnidsa8sfzzf4s1kgvb80qwffgxz5m8b";
    })
  ];

  doCheck = true;

  nativeBuildInputs = [
    meson ninja pkg-config wrapGAppsHook libxml2 gettext itstool
    desktop-file-utils appstream-glib libxslt docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ gtk3 glib gsettings-desktop-schemas gnome3.adwaita-icon-theme ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-dictionary";
      attrPath = "gnome3.gnome-dictionary";
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
