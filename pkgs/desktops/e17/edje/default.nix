{ stdenv, fetchurl, pkgconfig, lua, expat, zlib, libjpeg, eina, eet, evas
, ecore, embryo }:
stdenv.mkDerivation rec {
  name = "edje-${version}";
  version = "1.1.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.gz";
    sha256 = "0fjn4psl70hkfbjmczk06if8yxarg67w5hp2i1vq49kfkpyn2cx7";
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
