{stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, mysql, automoc4, soprano}:

stdenv.mkDerivation rec {
  name = "akonadi-1.4.3";
  src = fetchurl {
    url = "http://download.akonadi-project.org/${name}.tar.bz2";
    sha256 = "18xi66w78lsf2jf1z1vl8abps9hdv3g5msw6q1kj6xhmn4lbgjkk";
  };
  buildInputs = [ cmake qt4 shared_mime_info libxslt boost mysql automoc4 soprano ];
  patches = [ ./fix-broken-datadir-parameter.patch ];
  meta = with stdenv.lib; {
    description = "KDE PIM Storage Service";
    license = "LGPL";
    homepage = http://pim.kde.org/akonadi;
    maintainers = [ maintainers.sander maintainers.urkud ];
    platforms = platforms.linux;
  };
}
