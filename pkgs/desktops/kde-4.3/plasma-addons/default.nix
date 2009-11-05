{ stdenv, fetchurl, lib, cmake, qt4, perl, python, shared_mime_info
, kdelibs, kdebase_workspace, kdepimlibs, kdebase, kdegraphics, kdeedu
, automoc4, phonon, soprano, eigen, qimageblitz}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdeplasma-addons-4.3.3.tar.bz2;
    sha1 = "y8pl322b45ki3nnhcqjwpysir69s2x64";
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
