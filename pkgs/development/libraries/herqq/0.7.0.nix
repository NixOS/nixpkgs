{ stdenv, fetchurl, qt4, unzip }:

stdenv.mkDerivation rec {
  name = "herqq-0.7.0";


  buildInputs = [ qt4 unzip ];

  configurePhase = "qmake PREFIX=$out herqq.pro";

  src = fetchurl {
    url = "mirror://sourceforge/hupnp/${name}.zip";
    sha256 = "13z6wabakn2j57azhik9nvps50l85hrs028kkhn5cpd0pgcigmqz";
  };

  meta = {
    homepage = http://herqq.org;
    description = "A software library for building UPnP devices and control points";
    inherit (qt4.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
