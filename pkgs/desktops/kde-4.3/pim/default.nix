{ stdenv, fetchurl, lib, cmake, qt4, perl, boost, gpgme, libassuan, libgpgerror, libxslt
, shared_mime_info, libXScrnSaver
, kdelibs, kdelibs_experimental, kdepimlibs, automoc4, phonon, akonadi, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdepim-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdepim-4.3.5.tar.bz2;
    sha256 = "1lcgaak0avqjjpa9sh8pf8d9rksh7cvd3p42ia60rc72zp6yzy3n";
  };
  includeAllQtDirs=true;
  builder = ./builder.sh;  
  buildInputs = [ cmake qt4 perl boost gpgme stdenv.gcc.libc libassuan libgpgerror libxslt
                  shared_mime_info libXScrnSaver
                  kdelibs kdelibs_experimental kdepimlibs automoc4 phonon akonadi strigi soprano qca2 ];
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
