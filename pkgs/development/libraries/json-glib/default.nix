{ stdenv, fetchurl_gnome, glib, pkgconfig }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "json-glib";
    major = "0"; minor = "14"; patchlevel = "2"; extension = "xz";
    sha256 = "19wlpsbdnm3mq2a6yjpzj0cwrmlkarp2m5x6g63b0r2n7vxaa5mq";
  };

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = http://live.gnome.org/JsonGlib;
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
  };
}
