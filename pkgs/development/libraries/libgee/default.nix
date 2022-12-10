{ lib, stdenv, fetchurl, autoconf, vala, pkg-config, glib, gobject-introspection, gnome }:

stdenv.mkDerivation rec {
  pname = "libgee";
  version = "0.20.6";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "G/g09eENYMxhJNdO08HdONpkZ4f794ciILi0Bo5HbU0=";
  };

  doCheck = true;

  nativeBuildInputs = [ pkg-config autoconf vala gobject-introspection ];
  buildInputs = [ glib ];

  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${placeholder "dev"}/share/gir-1.0";
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "${placeholder "out"}/lib/girepository-1.0";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Utility library providing GObject-based interfaces and classes for commonly used data structures";
    homepage = "https://wiki.gnome.org/Projects/Libgee";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
