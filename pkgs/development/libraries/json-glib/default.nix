{ stdenv, fetchurlGnome, glib, pkgconfig, gobjectIntrospection, dbus }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurlGnome {
    project = "json-glib";
    major = "0";
    minor = "16";
    patchlevel = "2";
    extension = "xz";
    sha256 = "0b22yw0n87mg7a5lkqw1d7xqnm8qj1bwy0wklv9b2yn29qv7am59";
  };

  configureflags= "--with-introspection" ; 

  propagatedBuildInputs = [ glib gobjectIntrospection ];
  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://live.gnome.org/JsonGlib;
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
  };
}
