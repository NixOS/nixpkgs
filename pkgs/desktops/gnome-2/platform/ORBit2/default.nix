{stdenv, fetchurl_gnome, pkgconfig, glib, libIDL}:

stdenv.mkDerivation rec {
  name = src.pkgname;
  
  src = fetchurl_gnome {
    project = "ORBit2";
    major = "2"; minor = "14"; patchlevel = "19";
    sha256 = "0l3mhpyym9m5iz09fz0rgiqxl2ym6kpkwpsp1xrr4aa80nlh1jam";
  };

  buildNativeInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libIDL ];
}
