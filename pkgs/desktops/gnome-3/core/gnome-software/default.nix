{ stdenv, fetchurl, substituteAll, pkgconfig, meson, ninja, gettext, gnome3, wrapGAppsHook, packagekit, ostree
, glib, appstream-glib, libsoup, polkit, isocodes, gspell, libxslt, gobject-introspection, flatpak, fwupd
, gtk3, gsettings-desktop-schemas, gnome-desktop, libxmlb, gnome-online-accounts
, json-glib, libsecret, valgrind-light, docbook_xsl, docbook_xml_dtd_42, docbook_xml_dtd_43, gtk-doc, desktop-file-utils }:

let

  withFwupd = stdenv.isx86_64 || stdenv.isi686;

in

stdenv.mkDerivation rec {
  pname = "gnome-software";
  version = "3.34.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1zhi6zkphq0wfm9z2d1rp1ym8x52c7as4r8h2nrcd34mmv02xnm7";
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
    polkit flatpak libxmlb gnome-online-accounts
  ] ++ stdenv.lib.optionals withFwupd [
    fwupd
  ];

  mesonFlags = [
    "-Dubuntu_reviews=false"
    "-Dgudev=false"
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
    homepage = https://wiki.gnome.org/Apps/Software;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
