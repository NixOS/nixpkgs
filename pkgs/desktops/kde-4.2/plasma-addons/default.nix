{stdenv, fetchurl, cmake, qt4, perl, python, shared_mime_info,
 kdelibs, kdebase_workspace, kdepimlibs, kdegraphics, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdeplasma-addons-4.2.3.tar.bz2;
    sha1 = "9c825fe7b93fcccd6de44f168438f67cf0066f22";
  };
  inherit kdebase_workspace;
  builder = ./builder.sh;
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl python shared_mime_info
                  kdelibs kdebase_workspace kdepimlibs kdegraphics automoc4 phonon ];
}
