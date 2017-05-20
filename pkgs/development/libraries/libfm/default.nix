{ stdenv, fetchurl, glib, gtk2, intltool, menu-cache, pango, pkgconfig, vala_0_34
, extraOnly ? false }:
let
    inherit (stdenv.lib) optional;
in
stdenv.mkDerivation rec {
  name = if extraOnly
    then "libfm-extra-${version}"
    else "libfm-${version}";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/libfm-${version}.tar.xz";
    sha256 = "0nlvfwh09gbq8bkbvwnw6iqr918rrs9gc9ljb9pjspyg408bn1n7";
  };

  buildInputs = [ glib gtk2 intltool pango pkgconfig vala_0_34 ]
                ++ optional (!extraOnly) menu-cache;

  configureFlags = optional extraOnly "--with-extra-only";

  meta = with stdenv.lib; {
    homepage = "http://blog.lxde.org/?cat=28/";
    license = licenses.lgpl21Plus;
    description = "A glib-based library for file management";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
