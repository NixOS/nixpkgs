{ stdenv, fetchurl, pkgconfig, intltool, gnome3, wrapGAppsHook, packagekit
, appstream-glib, libsoup, polkit, attr, acl, libyaml, isocodes, gtkspell3
, json_glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ pkgconfig intltool wrapGAppsHook ];
  buildInputs = [ gnome3.gtk packagekit appstream-glib libsoup
                  gnome3.gsettings_desktop_schemas gnome3.gnome_desktop
		  gtkspell3 json_glib
                  polkit attr acl libyaml ];
  propagatedBuildInputs = [ isocodes ];

  postInstall = ''
    mkdir -p $out/share/xml/
    ln -s ${isocodes}/share/xml/iso-codes $out/share/xml/iso-codes
  '';

  meta = with stdenv.lib; {
    homepage = https://www.freedesktop.org/software/PackageKit/;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    description = "GNOME Software lets you install and update applications and system extensions.";
  };
}
