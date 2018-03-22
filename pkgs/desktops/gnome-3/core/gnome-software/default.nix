{ stdenv, fetchurl, substituteAll, pkgconfig, meson, ninja, gettext, gnome3, wrapGAppsHook, packagekit, ostree
, glib, appstream-glib, libsoup, polkit, isocodes, gtkspell3, libxslt
, json-glib, libsecret, valgrind-light, docbook_xsl, docbook_xml_dtd_42, gtk-doc, desktop-file-utils }:

stdenv.mkDerivation rec {
  name = "gnome-software-${version}";
  version = "3.26.7";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "00lfzvlicqd8gk5ijnjdi36ikmhdzvfjj993rpf7mm04ncw4k0za";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit isocodes;
    })
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext wrapGAppsHook libxslt docbook_xml_dtd_42
    valgrind-light docbook_xsl gtk-doc desktop-file-utils
  ];

  buildInputs = [
    gnome3.gtk glib packagekit appstream-glib libsoup
    gnome3.gsettings-desktop-schemas gnome3.gnome-desktop
    gtkspell3 json-glib libsecret ostree
    polkit
  ];

  # https://gitlab.gnome.org/GNOME/gnome-software/issues/320
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  mesonFlags = [
    "-Denable-flatpak=false"
    "-Denable-rpm=false"
    "-Denable-fwupd=false"
    "-Denable-oauth=false"
    "-Denable-ubuntu-reviews=false"
    "-Denable-gudev=false"
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
