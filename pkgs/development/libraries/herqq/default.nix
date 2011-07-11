{ stdenv, fetchurl, qt4, unzip }:

stdenv.mkDerivation rec {
  name = "herqq-1.0.0";

  buildInputs = [ qt4 unzip ];

  configurePhase = "qmake PREFIX=$out herqq.pro";

  src = fetchurl {
    url = "mirror://sourceforge/hupnp/${name}.zip";
    sha256 = "13klwszi7h7mvdz2ap0ac4dp7lc0gswp8lzzlwidhqfmf9pwgkyb";
  };

  meta = {
    homepage = http://herqq.org;
    description = "A software library for building UPnP devices and control points";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
