{ stdenv, fetchurl, autoconf, vala_0_32, pkgconfig, glib, gobjectIntrospection, gnome3 }:
let
  ver_maj = "0.6";
  ver_min = "8";
in
stdenv.mkDerivation rec {
  name = "libgee-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgee/${ver_maj}/${name}.tar.xz";
    sha256 = "1lzmxgz1bcs14ghfp8qqzarhn7s64ayx8c508ihizm3kc5wqs7x6";
  };

  doCheck = true;

  patches = [ ./fix_introspection_paths.patch ];

  buildInputs = [ autoconf vala_0_32 pkgconfig glib gobjectIntrospection ];

  meta = with stdenv.lib; {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.spacefrogg ] ++ gnome3.maintainers;
  };
}
