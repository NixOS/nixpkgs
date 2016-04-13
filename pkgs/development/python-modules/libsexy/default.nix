{ stdenv, fetchurl, buildPythonPackage, libsexy, pkgconfig, libxml2, pygtk, pango, gtk, glib, }:

stdenv.mkDerivation rec {
  name = "python-libsexy-${version}";
  version = "0.1.9";

  src = fetchurl {
    url = "http://releases.chipx86.com/libsexy/sexy-python/sexy-python-${version}.tar.gz";
    sha256 = "05bgcsxwkp63rlr8wg6znd46cfbhrzc5wh70jabsi654pxxjb39d";
  };

  buildInputs = [
    pkgconfig pygtk
  ];

  propagatedBuildInputs = [
    libsexy gtk glib pango libxml2
  ];

  postInstall = ''
    ln -s $out/lib/python*/site-packages/gtk-2.0/* $out/lib/python*/site-packages/
  '';

  meta = {
    description = "Python libsexy bindings";
  };
}
