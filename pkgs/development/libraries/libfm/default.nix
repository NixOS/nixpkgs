{ stdenv, fetchurl, glib, gtk, intltool, menu-cache, pango, pkgconfig, vala
, extraOnly ? false }:
let
    inherit (stdenv.lib) optional;
in
stdenv.mkDerivation {
  name = if extraOnly then "libfm-extra-1.2.3" else "libfm-1.2.3";
  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/libfm-1.2.3.tar.xz";
    sha256 = "1ygvw52262r3jp1f45m9cdpx5xgvd4rkyfszslfqvg2c99ig34n6";
  };

  buildInputs = [ glib gtk intltool pango pkgconfig vala ]
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
