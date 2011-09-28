{ stdenv, fetchurl, pkgconfig, lua, eina, eet, evas, ecore, embryo }:
stdenv.mkDerivation rec {
  name = "edje-${version}";
  version = "1.0.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.gz";
    sha256 = "0z7gjj4ccjr36ba763ijmjkya58fc173vpdw1m298zwhy8n4164j";
  };
  buildInputs = [ pkgconfig lua eina eet evas ecore embryo ];
  meta = {
    description = "Enlightenment's abstract GUI layout and animation object library";
    longDescription = ''
      Enlightenment's Edje is a complex graphical design & layout
      library based on Evas that provides an abstraction layer between
      the application code and the interface, while allowing extremely
      flexible dynamic layouts and animations.

      In more popular terms, Edje makes every application that uses it
      "skinable".
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.bsd2;  # not sure
  };
}
