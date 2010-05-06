{ stdenv, fetchurl, lib, cmake, qt4, perl, boost, gpgme, libassuan, libgpgerror, libxslt
, shared_mime_info, libXScrnSaver
, kdelibs, kdepimlibs, automoc4, phonon, akonadi, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdepim-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdepim-4.4.3.tar.bz2;
    sha256 = "0lpr9q1p89hw22d545yc9ih8m5wmnzc7j7m9cvliyalkk0ys5lqa";
  };
  builder = ./builder.sh;  
  buildInputs = [ cmake qt4 perl boost gpgme stdenv.gcc.libc libassuan libgpgerror libxslt
                  shared_mime_info libXScrnSaver
                  kdelibs kdepimlibs automoc4 phonon akonadi strigi soprano qca2 ];
  meta = {
    description = "KDE PIM tools";
    longDescription = ''
      Contains various personal information management tools for KDE, such as an organizer
    '';
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
