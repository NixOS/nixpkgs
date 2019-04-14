{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, glib, gtk3, wrapGAppsHook, desktop-file-utils
, gettext, itstool, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_43, systemd, python3 }:

stdenv.mkDerivation rec {
  name = "gnome-logs-${version}";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0hh3nnbq7q2xbflvaywanm0j3dqhb04ngphskhnjx2sg7px12068";
  };

  mesonFlags = [
    "-Dtests=true"
    "-Dman=true"
  ];

  nativeBuildInputs = [
    python3
    meson ninja pkgconfig wrapGAppsHook gettext itstool desktop-file-utils
    libxml2 libxslt docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [ glib gtk3 systemd gnome3.gsettings-desktop-schemas gnome3.adwaita-icon-theme ];

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
