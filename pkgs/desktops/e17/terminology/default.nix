{ stdenv, fetchurl, pkgconfig, elementary, eina, eet, evas, edje, emotion, ecore, ethumb, efreet }:

stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "0.3.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.gz";
    sha256 = "1dn5bjswqgnqza7bngc6afqza47yh27xfwf5qg2kzfgs008hp1bp";
  };
  buildInputs = [ pkgconfig elementary eina eet evas ecore edje emotion ecore ethumb efreet ];

  meta = {
    description = "Terminology, the E17 terminal emulator";
    homepage = http://www.enlightenment.org/p.php?p=about/terminology;
    license = stdenv.lib.licenses.bsd2;  # not sure
  };
}
