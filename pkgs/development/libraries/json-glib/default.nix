{ stdenv, fetchurl, glib, pkgconfig, gobjectIntrospection, dbus }:

stdenv.mkDerivation rec {
  name = "json-glib-${minVer}.2";
  minVer = "1.0";

  src = fetchurl {
    url = "mirror://gnome/sources/json-glib/${minVer}/${name}.tar.xz";
    sha256 = "887bd192da8f5edc53b490ec51bf3ffebd958a671f5963e4f3af32c22e35660a";
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
