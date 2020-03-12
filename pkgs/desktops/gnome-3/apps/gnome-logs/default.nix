{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, glib, gtk3, wrapGAppsHook
, gettext, itstool, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_43, systemd, python3, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "gnome-logs";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "16jfwg912asirrdmipf6wh7zr5zrww3nyhf99mi230y8hmqazx0m";
  };

  mesonFlags = [
    "-Dman=true"
  ];

  nativeBuildInputs = [
    python3
    meson ninja pkgconfig wrapGAppsHook gettext itstool
    libxml2 libxslt docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ glib gtk3 systemd gsettings-desktop-schemas gnome3.adwaita-icon-theme ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  doCheck = true;

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
