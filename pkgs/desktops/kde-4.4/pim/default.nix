{ stdenv, fetchurl, lib, cmake, qt4, perl, boost, gpgme, libassuan, libgpgerror, libxslt
, shared_mime_info, libXScrnSaver
, kdelibs, kdepimlibs, automoc4, phonon, akonadi, strigi, soprano, qca2}:

stdenv.mkDerivation {
  name = "kdepim-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdepim-4.4.5.tar.bz2;
    sha256 = "0n95wjk1ly7zfn9wv589a9hrc0r7wvik7jrvsgimnxr0rapxk3bp";
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
    inherit (kdelibs.meta) maintainers platforms;
  };
}
