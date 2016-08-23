{ stdenv, fetchurl, glib, gtk, intltool, menu-cache, pango, pkgconfig, vala_0_23
, extraOnly ? false }:
let
    inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = if extraOnly
    then "libfm-extra-${version}"
    else "libfm-${version}";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/libfm-${version}.tar.xz";
    sha256 = "0bsh4p7h2glhxf1cc1lvbxyb4qy0y1zsnl9izf7vrldkikrgc13q";
  };

  buildInputs = [ glib gtk intltool pango pkgconfig vala_0_23 ]
                ++ optional (!extraOnly) menu-cache;

  configureFlags = optional extraOnly "--with-extra-only";

  meta = with stdenv.lib; {
    homepage = "http://blog.lxde.org/?cat=28/";
    license = licenses.lgpl21Plus;
    description = "A glib-based library for file management";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
  };
}
