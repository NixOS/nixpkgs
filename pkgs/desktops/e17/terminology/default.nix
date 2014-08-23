{ stdenv, fetchurl, pkgconfig, elementary, eina, eet, evas, edje, emotion, ecore, ethumb, efreet }:

stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "0.5.1";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.gz";
    sha256 = "1b8m6fhzx2fdr3m6ak2163v33zc4svmg2k875m0xppzifdd9xvyf";
  };
  buildInputs = [ pkgconfig elementary eina eet evas ecore edje emotion ecore ethumb efreet ];

  meta = {
    description = "Terminology, the E17 terminal emulator";
    homepage = http://www.enlightenment.org/p.php?p=about/terminology;
    license = stdenv.lib.licenses.bsd2;  # not sure
  };
}
