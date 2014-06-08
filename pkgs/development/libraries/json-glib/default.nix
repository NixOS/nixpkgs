{ stdenv, fetchurlGnome, glib, pkgconfig, gobjectIntrospection, dbus }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurlGnome {
    project = "json-glib";
    major = "1";
    minor = "0";
    patchlevel = "0";
    extension = "xz";
    sha256 = "dbf558d2da989ab84a27e4e13daa51ceaa97eb959c2c2f80976c9322a8f4cdde";
  };

  configureflags= "--with-introspection" ; 

  propagatedBuildInputs = [ glib gobjectIntrospection ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = http://live.gnome.org/JsonGlib;
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ lethalman ];
  };
}
