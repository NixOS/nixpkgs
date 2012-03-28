{ stdenv, fetchurl, pkgconfig, lua, expat, zlib, libjpeg, eina, eet, evas
, ecore, embryo }:
stdenv.mkDerivation rec {
  name = "edje-${version}";
  version = "1.2.0-alpha";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "15vh0plb9gb75q0lgbqv4kjz0pyhbfxk39x3inzn87ih567z73xx";
  };
  buildInputs = [ pkgconfig expat zlib libjpeg lua eina eet evas ecore embryo ];
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
