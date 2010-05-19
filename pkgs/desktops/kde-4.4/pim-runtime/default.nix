{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, shared_mime_info
, kdelibs, kdepimlibs
, automoc4, phonon, akonadi, soprano, strigi}:

stdenv.mkDerivation {
  name = "kdepim-runtime-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdepim-runtime-4.4.3.tar.bz2;
    sha256 = "128azx9bw2fzc9780kf9pzvf745y8kflyb2vrb7mdwmskbr0gm3g";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost shared_mime_info
                  kdelibs kdepimlibs
		  automoc4 phonon akonadi soprano strigi ];
  builder = ./builder.sh;
  meta = {
    description = "KDE PIM runtime";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
