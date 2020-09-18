{ stdenv, fetchurl, substituteAll, pkgconfig, meson, ninja, gettext, gnome3, wrapGAppsHook, packagekit, ostree
, glib, appstream-glib, libsoup, polkit, isocodes, gspell, libxslt, gobject-introspection, flatpak, fwupd
, gtk3, gsettings-desktop-schemas, gnome-desktop, libxmlb, gnome-online-accounts
, json-glib, libsecret, valgrind-light, docbook_xsl, docbook_xml_dtd_42, docbook_xml_dtd_43, gtk-doc, desktop-file-utils
, sysprof }:

let

  withFwupd = stdenv.isx86_64 || stdenv.isi686;

in

stdenv.mkDerivation rec {
  pname = "gnome-software";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0rjm486vgn6gi9mv1rqdcvr9cilmw6in4r6djqkxbxqll89cp2l7";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit isocodes;
    })
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext wrapGAppsHook libxslt docbook_xml_dtd_42 docbook_xml_dtd_43
    valgrind-light docbook_xsl gtk-doc desktop-file-utils gobject-introspection
  ];

  buildInputs = [
    gtk3 glib packagekit appstream-glib libsoup
    gsettings-desktop-schemas gnome-desktop
    gspell json-glib libsecret ostree
    polkit flatpak libxmlb gnome-online-accounts sysprof
  ] ++ stdenv.lib.optionals withFwupd [
    fwupd
  ];

  mesonFlags = [
    "-Dubuntu_reviews=false"
    "-Dgudev=false"
    # FIXME: package malcontent parental controls
    "-Dmalcontent=false"
  ] ++ stdenv.lib.optionals (!withFwupd) [
    "-Dfwupd=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-software";
      attrPath = "gnome3.gnome-software";
    };
  };

  meta = with stdenv.lib; {
    description = "Software store that lets you install and update applications and system extensions";
    homepage = "https://wiki.gnome.org/Apps/Software";
    license = licenses.gpl2;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
