{stdenv, fetchurl, pkgconfig, glib, libxml2, gtkdoc}:

let
  pname = "gdome2";
  version = "0.8.1";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://gdome2.cs.unibo.it/tarball/${pname}-${version}.tar.gz";
    sha256 = "0hyms5s3hziajp3qbwdwqjc2xcyhb783damqg8wxjpwfxyi81fzl";
  };

  buildInputs = [pkgconfig glib libxml2 gtkdoc];
  propagatedBuildInputs = [glib libxml2];

  meta = {
    homepage = http://gdome2.cs.unibo.it/;
    description = "DOM C library developped for the Gnome project";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
