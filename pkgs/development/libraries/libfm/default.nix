{ stdenv, fetchurl, glib, gtk, intltool, menu-cache, pango, pkgconfig, vala
, extraOnly ? false }:
let name = "libfm-1.2.2.1";
    inherit (stdenv.lib) optional;
in
stdenv.mkDerivation {
  name = if extraOnly then "libfm-extra-1.2.2.1" else "libfm-1.2.2.1";
  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/libfm-1.2.2.1.tar.xz";
    sha256 = "0aa37arr0h2nppjh7ppf00np2d8mb43imvfq9b7wq5cnzpvs7c6v";
  };

  buildInputs = [ glib gtk intltool pango pkgconfig vala ]
                ++ optional (!extraOnly) menu-cache;

  configureFlags = optional extraOnly "--with-extra-only";

  meta = with stdenv.lib; {
    homepage = "http://blog.lxde.org/?cat=28/";
    license = licenses.gpl2Plus;
    description = "A glib-based library for file management";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
  };
}
