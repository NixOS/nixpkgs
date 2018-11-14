{ stdenv, fetchurl, glib, intltool, menu-cache, pango, pkgconfig, vala
, extraOnly ? false
, withGtk3 ? false, gtk2, gtk3 }:
let
    gtk = if withGtk3 then gtk3 else gtk2;
    inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = if extraOnly
    then "libfm-extra-${version}"
    else "libfm-${version}";
  version = "1.3.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/libfm-${version}.tar.xz";
    sha256 = "0wkwbi1nyvqza3r1dhrq846axiiq0fy0dqgngnagh76fjrwnzl0q";
  };

  nativeBuildInputs = [ vala pkgconfig intltool ];
  buildInputs = [ glib gtk pango ] ++ optional (!extraOnly) menu-cache;

  configureFlags = optional extraOnly "--with-extra-only"
    ++ optional withGtk3 "--with-gtk=3";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://blog.lxde.org/?cat=28/;
    license = licenses.lgpl21Plus;
    description = "A glib-based library for file management";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
