{stdenv, fetchurl, pkgconfig, glib, libxml2, gtk-doc}:

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

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libxml2 gtk-doc ];
  propagatedBuildInputs = [glib libxml2];
  patches = [ ./xml-document.patch ];

  meta = with stdenv.lib; {
    homepage = http://gdome2.cs.unibo.it/;
    description = "DOM C library developed for the Gnome project";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ prikhi roconnor ];
    platforms = platforms.linux;
  };
}
