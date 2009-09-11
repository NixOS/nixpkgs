{ stdenv, fetchurl, lib, cmake, qt4, perl, python, shared_mime_info
, kdelibs, kdebase_workspace, kdepimlibs, kdebase, kdegraphics, kdeedu
, automoc4, phonon, soprano, eigen, qimageblitz}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.3.1";
  src = fetchurl {
    url = mirror://kde/stable/4.3.1/src/kdeplasma-addons-4.3.1.tar.bz2;
    sha1 = "83421181dd3a80c4ac0ff5bab111b7f71f6a1192";
  };
  inherit kdebase_workspace;
  builder = ./builder.sh;
  includeAllQtDirs=true;
  CMAKE_PREFIX_PATH=kdepimlibs;
  KDEDIRS="${kdeedu}";
  buildInputs = [ cmake qt4 perl python shared_mime_info
                  kdelibs kdebase_workspace kdepimlibs kdebase kdegraphics kdeedu
		  automoc4 phonon soprano eigen qimageblitz ];
  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
