{ stdenv, fetchurl, pkgconfig, eina, evas, ecore, edje, eet }:
stdenv.mkDerivation rec {
  name = "ethumb-${version}";
  version = "1.7.5";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "0prka3knz8p2n46dfrzgwn55khhhrhjny4vvnzkjcwmhvz7kgc9l";
  };
  buildInputs = [ pkgconfig eina evas ecore edje eet ];
  meta = {
    description = "A thumbnail generation library";
    longDescription = ''
      Ethumb - thumbnail generation library. Features:
      * create thumbnails with a predefined frame (possibly an edje frame);
      * have an option to create fdo-like thumbnails;
      * have a client/server utility;
      * TODO: make thumbnails from edje backgrounds, icons and themes; 
    '';
    homepage = http://enlightenment.org/;
    license = stdenv.lib.licenses.lgpl21;
  };
}
