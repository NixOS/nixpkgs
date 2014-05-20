{ stdenv, fetchurl, autoconf, vala, pkgconfig, glib, gobjectIntrospection }:
let
  ver_maj = "0.14";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "libgee-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgee/${ver_maj}/${name}.tar.xz";
    sha256 = "08e466d3f214c9466860b5a82629de0de9eb89b1de7bd918fe154e569b5834cd";
  };

  doCheck = true;

  patches = [ ./fix_introspection_paths.patch ];

  buildInputs = [ autoconf vala pkgconfig glib gobjectIntrospection ];

  meta = with stdenv.lib; {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
