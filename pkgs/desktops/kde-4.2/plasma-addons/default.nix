{stdenv, fetchurl, cmake, qt4, perl, python, shared_mime_info,
 kdelibs, kdebase_workspace, kdepimlibs, kdegraphics, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdeplasma-addons-4.2.4.tar.bz2;
    sha1 = "500d05cc6eeb218b8615b1a49e69e3b9e88f3997";
  };
  inherit kdebase_workspace;
  builder = ./builder.sh;
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl python shared_mime_info
                  kdelibs kdebase_workspace kdepimlibs kdegraphics automoc4 phonon ];
}
