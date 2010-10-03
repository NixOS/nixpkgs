{ stdenv, fetchurl, glib, pkgconfig }:

let
  pname = "json-glib";
  version = "0.10.4";
in
stdenv.mkDerivation rec {
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/0.10/${name}.tar.bz2";
    sha256 = "1naydnjagxw5gsq77lhaasjzfv1kp19v6bkybg1krq7rsd0v7n7g";
  };

  propagatedBuildInputs = [ glib ];
  buildInputs = [ pkgconfig ];

  meta = {
    homepage = http://live.gnome.org/JsonGlib;
    description = "A library providing (de)serialization support for the JavaScript Object Notation (JSON) format";
  };
}
