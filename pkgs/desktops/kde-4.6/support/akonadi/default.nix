{stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, mysql, automoc4, soprano}:

stdenv.mkDerivation rec {
  name = "akonadi-1.4.90";
  src = fetchurl {
    url = "http://download.akonadi-project.org/${name}.tar.bz2";
    sha256 = "0am4m81zhq343a42s1ig5jxx47i6g1d97r546qqzdm5w542r6c00";
  };
  buildInputs = [ cmake qt4 shared_mime_info libxslt boost mysql automoc4 soprano ];
  meta = with stdenv.lib; {
    description = "KDE PIM Storage Service";
    license = "LGPL";
    homepage = http://pim.kde.org/akonadi;
    maintainers = [ maintainers.sander maintainers.urkud ];
    platforms = platforms.linux;
  };
}
