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
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/libfm-${version}.tar.xz";
    sha256 = "1r6gl49xrykldwz8y4h2s7gjarxigg3bbkrj0gphxjj1vr5j9ccn";
  };

  nativeBuildInputs = [ vala pkgconfig intltool ];
  buildInputs = [ glib gtk pango ] ++ optional (!extraOnly) menu-cache;

  configureFlags = [
    "--sysconfdir=/etc"
  ] ++ optional extraOnly "--with-extra-only"
    ++ optional withGtk3 "--with-gtk=3";

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://blog.lxde.org/category/pcmanfm/;
    license = licenses.lgpl21Plus;
    description = "A glib-based library for file management";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
