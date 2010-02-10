{stdenv, fetchurl, lib, cmake, qt4, tapioca_qt, telepathy_qt}:

stdenv.mkDerivation {
  name = "decibel-0.5.0";
  src = fetchurl {
    url = http://decibel.kde.org/fileadmin/downloads/decibel/releases/decibel-0.5.0.tar.gz;
    md5 = "7de299ace568c87a746388ad765228e5";
  };
  buildInputs = [ cmake qt4 tapioca_qt telepathy_qt ];
  meta = {
    description = "Realtime communications framework for KDE";
    license = "LGPL";
    homepage = http://decibel.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
