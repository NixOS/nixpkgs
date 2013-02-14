{ stdenv, fetchurl, pkgconfig, lua, expat, zlib, libjpeg, eina, eet, evas
, ecore, embryo }:
stdenv.mkDerivation rec {
  name = "edje-${version}";
  version = "1.7.5";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "1hsyj46bk94yd9ymf9425pf4ygy36h5gdkg9fhf8qds8cnn2kcy7";
  };
  buildInputs = [ pkgconfig expat zlib libjpeg lua eina eet evas ecore embryo ];
  patchPhase = ''
    substituteInPlace src/bin/edje_cc_out.c --replace '%s/embryo_cc' '${embryo}/bin/embryo_cc'
    substituteInPlace src/bin/edje_cc_out.c --replace 'eina_prefix_bin_get(pfx),' ""
  '';
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
