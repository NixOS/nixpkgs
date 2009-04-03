{stdenv, fetchurl, cmake, qt4, perl, python, shared_mime_info,
 kdelibs, kdebase_workspace, kdepimlibs, kdegraphics, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdeplasma-addons-4.2.2.tar.bz2;
    sha1 = "6b4afe369597b8cdeff05e1b0feda0d48aea59d6";
  };
  inherit kdebase_workspace;
  builder = ./builder.sh;
  CMAKE_PREFIX_PATH=kdepimlibs;
  buildInputs = [ cmake qt4 perl python shared_mime_info
                  kdelibs kdebase_workspace kdepimlibs kdegraphics automoc4 phonon ];
}
