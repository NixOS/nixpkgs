{ stdenv, fetchurl_gnome, glib, pkgconfig }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "json-glib";
    major = "0"; minor = "14"; patchlevel = "0"; extension = "xz";
    sha256 = "0mpw996cyidspjwns281l5haj9i8azpkfpl4jf98lh3kcqcr07l2";
  };

  propagatedBuildInputs = [ glib ];
  buildNativeInputs = [ pkgconfig ];

  meta = {
    homepage = http://live.gnome.org/JsonGlib;
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
  };
}
