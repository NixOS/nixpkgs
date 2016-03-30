{ stdenv, fetchurl, glib, pkgconfig, gobjectIntrospection, dbus }:

stdenv.mkDerivation rec {
  name = "json-glib-${minVer}.0";
  minVer = "1.2";

  src = fetchurl {
    url = "mirror://gnome/sources/json-glib/${minVer}/${name}.tar.xz";
    sha256 = "1lx7p1c7cl21byvfgw92n8dhm09vi6qxrs0zkx9dg3y096zdzmlr";
  };

  configureflags= "--with-introspection";

  propagatedBuildInputs = [ glib gobjectIntrospection ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://live.gnome.org/JsonGlib;
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ lethalman ];
  };
}
