{ stdenv, fetchurl, pkgconfig, elementary, eina, eet, evas, edje, emotion, ecore, ethumb, efreet }:

stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "0.7.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.gz";
    sha256 = "1x248dh9r292r8ycvf43vrfk4l8wpli50sgywp0zy3q93f8ljgs5";
  };
  buildInputs = [ pkgconfig elementary eina eet evas ecore edje emotion ecore ethumb efreet ];

  meta = {
    description = "Terminology, the E17 terminal emulator";
    homepage = http://www.enlightenment.org/p.php?p=about/terminology;
    license = stdenv.lib.licenses.bsd2;  # not sure
  };
}
