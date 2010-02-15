{ stdenv, fetchurl, lib, cmake, qt4, perl, python, shared_mime_info
, kdelibs, kdebase_workspace, kdepimlibs, kdebase, kdegraphics, kdeedu
, automoc4, phonon, soprano, eigen, qimageblitz}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.3.5";
  src = fetchurl {
    url = mirror://kde/stable/4.3.5/src/kdeplasma-addons-4.3.5.tar.bz2;
    sha256 = "0fmmghhywxi0rszl8gjsbd4f0ncvligcc7gqfcn9s2fs32v6ypxp";
  };
  inherit kdebase_workspace;
  builder = ./builder.sh;
  includeAllQtDirs=true;
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
