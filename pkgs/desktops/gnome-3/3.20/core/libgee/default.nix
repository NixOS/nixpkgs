{ stdenv, fetchurl, autoconf, vala_0_32, pkgconfig, glib, gobjectIntrospection, gnome3 }:
let
  ver_maj = "0.16";
  ver_min = "1";
in
stdenv.mkDerivation rec {
  name = "libgee-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgee/${ver_maj}/${name}.tar.xz";
    sha256 = "d95f8ea8e78f843c71b1958fa2fb445e4a325e4821ec23d0d5108d8170e564a5";
  };

  doCheck = true;

  patches = [ ./fix_introspection_paths.patch ];

  buildInputs = [ autoconf vala_0_32 pkgconfig glib gobjectIntrospection ];

  meta = with stdenv.lib; {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
