{ stdenv, fetchurl, lib, cmake, qt4, perl, python, shared_mime_info
, kdelibs, kdebase_workspace, kdepimlibs, kdebase, kdegraphics, kdeedu
, automoc4, phonon, soprano, eigen, qimageblitz}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdeplasma-addons-4.3.4.tar.bz2;
    sha1 = "0b7af5db24fd194dd5fbbe1690d4ea62f597b891";
  };
  inherit kdebase_workspace;
  builder = ./builder.sh;
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
