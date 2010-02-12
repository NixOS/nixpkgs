{ stdenv, fetchurl, lib, cmake, qt4, perl, boost, gpgme, libassuan, libgpgerror, libxslt
, shared_mime_info, libXScrnSaver
, kdelibs, kdelibs_experimental, kdepimlibs, automoc4, phonon, akonadi, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdepim-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdepim-4.3.4.tar.bz2;
    sha1 = "3ddc34c2b0c96c0273431631ccf47a8b9b4289b3";
  };
  CMAKE_PREFIX_PATH=kdepimlibs;
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
