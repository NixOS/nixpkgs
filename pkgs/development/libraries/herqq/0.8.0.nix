{ stdenv, fetchurl, qt4, unzip }:

stdenv.mkDerivation rec {
  name = "herqq-0.8.0";


  buildInputs = [ qt4 unzip ];

  configurePhase = "qmake PREFIX=$out herqq.pro";

  src = fetchurl {
    url = "mirror://sourceforge/hupnp/${name}.zip";
    sha256 = "0z1z9f48fhdif3wd7gn2gj0yxk15f0lpm01q0igsccv8m1y3mphn";
  };

  meta = {
    homepage = http://herqq.org;
    description = "A software library for building UPnP devices and control points";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
