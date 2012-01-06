{ stdenv, fetchurl, cmake, kdelibs, qt4, automoc4, phonon, libkexiv2
, libkdcraw, libkipi, gettext, libxml2, libxslt, qjson, qca2
, kdepimlibs }:

stdenv.mkDerivation rec {
  name = "kipi-plugins-1.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/kipi/${name}.tar.bz2";
    sha256 = "0k4k9v1rj7129n0s0i5pvv4rabx0prxqs6sca642fj95cxc6c96m";
  };

  buildInputs =
    # Some dependencies are missing because they are very big (OpenCV,
    # GTK).
    [ cmake kdelibs qt4 automoc4 phonon libkexiv2 libkdcraw libkipi
      gettext libxml2 libxslt qjson qca2 kdepimlibs
    ];

  enableParallelBuilding = true;

  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.kipi-plugins.org;
    inherit (kdelibs.meta) platforms;
    maintainers = with stdenv.lib.maintainers; [ viric urkud ];
  };
}
