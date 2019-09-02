{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libcanberra-gtk3, clutter-gtk, intltool, itstool
, libxml2, libgee, libgnome-games-support }:

stdenv.mkDerivation rec {
  pname = "gnome-nibbles";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-nibbles/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0g627pzbfywiy2rsh4aidgbln9s4j5m8pryw4cgr5ygc4z8l6l9p";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook intltool itstool libxml2 ];
  buildInputs = [
    gtk3 librsvg libcanberra-gtk3 clutter-gtk gnome3.adwaita-icon-theme
    libgee libgnome-games-support
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-nibbles";
      attrPath = "gnome3.gnome-nibbles";
    };
  };

  meta = with stdenv.lib; {
    description = "Guide a worm around a maze";
    homepage = https://wiki.gnome.org/Apps/Nibbles;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
