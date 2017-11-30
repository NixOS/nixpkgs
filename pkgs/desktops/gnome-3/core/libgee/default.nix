{ stdenv, fetchurl, autoconf, vala, pkgconfig, glib, gobjectIntrospection, gnome3 }:
let
  ver_maj = "0.20";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "libgee-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgee/${ver_maj}/${name}.tar.xz";
    sha256 = "1fy24dr8imrjlmsqj1syn0gi139gba6hwk3j5vd6sr3pxniqnc11";
  };

  doCheck = true;

  patches = [ ./fix_introspection_paths.patch ];

  nativeBuildInputs = [ pkgconfig autoconf vala gobjectIntrospection ];
  buildInputs = [ glib ];

  meta = with stdenv.lib; {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
