{ stdenv, fetchurl, autoconf, vala, pkgconfig, glib, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libgee";
  version = "0.20.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0g1mhl7nidg82v4cikkk8dakzc18hg7wv0dsf2pbyijzfm5mq0wy";
  };

  doCheck = true;

  nativeBuildInputs = [ pkgconfig autoconf vala gobject-introspection ];
  buildInputs = [ glib ];

  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${placeholder "dev"}/share/gir-1.0";
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "${placeholder "out"}/lib/girepository-1.0";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    homepage = https://wiki.gnome.org/Projects/Libgee;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
