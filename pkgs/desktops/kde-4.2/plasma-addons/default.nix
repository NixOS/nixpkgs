{stdenv, fetchurl, cmake, qt4, perl, python, shared_mime_info,
 kdelibs, kdebase_workspace, kdepimlibs, kdegraphics, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdeplasma-addons-4.2.0.tar.bz2;
    md5 = "d98f805f4c9b7af7278067f9e544b2ec";
  };
  inherit kdebase_workspace;
  builder = ./builder.sh;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl python shared_mime_info
                  kdelibs kdebase_workspace kdepimlibs kdegraphics automoc4 phonon ];
}
