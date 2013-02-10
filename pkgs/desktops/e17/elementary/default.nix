{ stdenv, fetchurl, pkgconfig, eina, eet, evas, ecore, edje }:
stdenv.mkDerivation rec {
  name = "elementary-${version}";
  version = "1.7.5";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "08cb4x9639xyrb8d4vzvhl6v385qjfswl717sicm7iimh5zlm2l9";
  };
  buildInputs = [ pkgconfig eina eet evas ecore edje ];
  meta = {
    description = "Enlightenment's core data structure library";
    longDescription = ''
      Enlightenment's Eina is a core data structure and common utility
      library.
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.lgpl21;
  };
}
