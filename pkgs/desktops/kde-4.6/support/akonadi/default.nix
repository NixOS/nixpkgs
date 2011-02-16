{stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, mysql, automoc4, soprano}:

stdenv.mkDerivation rec {
  name = "akonadi-1.5.0";
  src = fetchurl {
    url = "http://download.akonadi-project.org/${name}.tar.bz2";
    sha256 = "1azk2g7vb2sampxlys1hkgf9jvzpv92afsjdl31ikqbckaqnbfqc";
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
