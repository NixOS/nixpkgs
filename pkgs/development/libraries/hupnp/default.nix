{ stdenv, fetchsvn, qt4 }:

stdenv.mkDerivation {
  name = "hupnp-0.8.0-r91";


  buildInputs = [ qt4 ];

  configurePhase = "cd herqq; qmake PREFIX=$out herqq.pro";

  src = fetchsvn {
    url = http://hupnp.svn.sourceforge.net/svnroot/hupnp/trunk;
    rev = 91;
    sha256 = "1lhg22wy95pkxsvs6yxz4k84sslngphwf2aj5yw1bzrzzc486hqd";
  };

  meta = {
    homepage = http://herqq.org;
    description = "A software library for building UPnP devices and control points";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
