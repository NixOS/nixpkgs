{ stdenv, fetchurl, lib, cmake, qt4, perl, python, shared_mime_info, libXtst, libXi
, kdelibs, kdebase_workspace, kdepimlibs, kdebase, kdegraphics, kdeedu
, automoc4, phonon, soprano, eigen, qimageblitz, attica}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.4.4";
  src = fetchurl {
    url = mirror://kde/stable/4.4.4/src/kdeplasma-addons-4.4.4.tar.bz2;
    sha256 = "0pmll98l9d1yh8yfsfqd970bs346xkfi2h4a6vxmm643xsr59d2d";
  };
  inherit kdebase_workspace;
  builder = ./builder.sh;
  KDEDIRS="${kdeedu}";
  buildInputs = [ cmake qt4 perl python shared_mime_info libXtst libXi
                  kdelibs kdebase_workspace kdepimlibs kdebase kdegraphics kdeedu
		  automoc4 phonon soprano eigen qimageblitz attica ];
  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
