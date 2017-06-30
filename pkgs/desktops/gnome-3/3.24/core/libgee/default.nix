{ stdenv, fetchurl, autoconf, vala_0_32, pkgconfig, glib, gobjectIntrospection, gnome3 }:
let
  ver_maj = "0.18";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "libgee-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgee/${ver_maj}/${name}.tar.xz";
    sha256 = "16a34js81w9m2bw4qd8csm4pcgr3zq5z87867j4b8wfh6zwrxnaa";
  };

  doCheck = true;

  patches = [ ./fix_introspection_paths.patch ];

  buildInputs = [ autoconf vala_0_32 pkgconfig glib gobjectIntrospection ];

  meta = with stdenv.lib; {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
