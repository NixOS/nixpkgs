{stdenv, fetchurl, python, pkgconfig, libxml2Python, libxslt, intltool
, makeWrapper, pythonPackages }:

stdenv.mkDerivation {
  name = "gnome-doc-utils-0.18.1";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-doc-utils/0.18/gnome-doc-utils-0.18.1.tar.bz2;
    sha256 = "0psl9xnph6qga809dbkakjfp2z9mc32dxrdk8s6zn8whm41gc0gn";
  };

  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ python libxml2Python libxslt ];
  postInstall = "wrapPythonPrograms";

  buildNativeInputs = [ pkgconfig intltool pythonPackages.wrapPython ];
}
