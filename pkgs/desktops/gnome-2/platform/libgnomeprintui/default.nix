{ lib, stdenv, fetchurl, pkg-config, gtk2, gettext, intltool, libgnomecanvas, libgnomeprint, gnome-icon-theme }:

stdenv.mkDerivation rec {
  pname = "libgnomeprintui";
  version = "2.18.6";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomeprintui/${lib.versions.majorMinor version}/libgnomeprintui-${version}.tar.bz2";
    sha256 = "0spl8vinb5n6n1krnfnr61dwaxidg67h8j94z9p59k2xdsvfashm";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 gettext intltool libgnomecanvas libgnomeprint gnome-icon-theme];
}
