{ stdenv, fetchurl, pkgconfig, meson, ninja, gettext, gnome3, wrapGAppsHook, packagekit, ostree
, glib, appstream-glib, libsoup, polkit, attr, acl, libyaml, isocodes, gtkspell3, libxslt
, json_glib, libsecret, valgrind-light, docbook_xsl, docbook_xml_dtd_42, gtk_doc, desktop_file_utils }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig meson ninja gettext wrapGAppsHook libxslt docbook_xml_dtd_42
                        valgrind-light docbook_xsl gtk_doc desktop_file_utils ];
  buildInputs = [ gnome3.gtk glib packagekit appstream-glib libsoup
                  gnome3.gsettings_desktop_schemas gnome3.gnome_desktop
                  gtkspell3 json_glib libsecret ostree
                  polkit attr acl libyaml ];
  propagatedBuildInputs = [ isocodes ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  postPatch = ''
    patchShebangs meson_post_install.sh
  '';

  mesonFlags = [
    "-Denable-flatpak=false"
    "-Denable-rpm=false"
    "-Denable-fwupd=false"
    "-Denable-oauth=false"
    "-Denable-ubuntu-reviews=false"
    "-Denable-gudev=false"
  ];

  postInstall = ''
    mkdir -p $out/share/xml/
    ln -s ${isocodes}/share/xml/iso-codes $out/share/xml/iso-codes
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.freedesktop.org/software/PackageKit/;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    description = "GNOME Software lets you install and update applications and system extensions.";
  };
}
