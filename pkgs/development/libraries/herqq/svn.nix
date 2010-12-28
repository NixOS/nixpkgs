{ stdenv, fetchsvn, qt4 }:

stdenv.mkDerivation {
  name = "herqq-0.8.0-r91";


  buildInputs = [ qt4 ];

  configurePhase = "qmake PREFIX=$out herqq.pro";

  src = fetchsvn {
    url = http://hupnp.svn.sourceforge.net/svnroot/hupnp/trunk/herqq;
    rev = 91;
    sha256 = "122md1kn8b5a1vdpn5kisqi6xklwwa57r4lacm1rxlkq3rpca864";
  };

  meta = {
    homepage = http://herqq.org;
    description = "A software library for building UPnP devices and control points";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
