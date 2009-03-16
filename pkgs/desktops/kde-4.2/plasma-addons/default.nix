{stdenv, fetchurl, cmake, qt4, perl, python, shared_mime_info,
 kdelibs, kdebase_workspace, kdepimlibs, kdegraphics, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdeplasma-addons-4.2.1.tar.bz2;
    sha1 = "8e164a8e1476862392371f765372c2e168895d55";
  };
  inherit kdebase_workspace;
  builder = ./builder.sh;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl python shared_mime_info
                  kdelibs kdebase_workspace kdepimlibs kdegraphics automoc4 phonon ];
}
