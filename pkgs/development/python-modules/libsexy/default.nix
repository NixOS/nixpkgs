{ stdenv, fetchurl, buildPythonPackage, libsexy, pkgconfig, libxml2, pygtk, pango, glib, python }:

buildPythonPackage rec {
  pname = "libsexy";
  version = "0.1.9";
  format = "other";

  src = fetchurl {
    url = "http://releases.chipx86.com/libsexy/sexy-python/sexy-python-${version}.tar.gz";
    sha256 = "05bgcsxwkp63rlr8wg6znd46cfbhrzc5wh70jabsi654pxxjb39d";
  };

  nativeBuildInputs = [ pkgconfig pygtk ];

  propagatedBuildInputs = [
    pygtk libsexy glib pango libxml2
  ];

  postInstall = ''
    ln -s $out/${python.sitePackages}/gtk-2.0/* $out/${python.sitePackages}
  '';

  meta = {
    description = "Python libsexy bindings";
    platforms = stdenv.lib.platforms.linux;
  };
}
