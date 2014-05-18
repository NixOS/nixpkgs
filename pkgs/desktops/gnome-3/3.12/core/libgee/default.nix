{ stdenv, fetchurl, autoconf, vala, pkgconfig, glib, gobjectIntrospection }:
let
  ver_maj = "0.12";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "libgee-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgee/${ver_maj}/${name}.tar.xz";
    sha256 = "19bf94ia1h5z8h0hdhwcd2b2p6ngffirg0dai7pdb98dzriys1ni";
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
