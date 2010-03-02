{ stdenv, fetchurl, lib, cmake, qt4, perl, python, shared_mime_info, libXtst, libXi
, kdelibs, kdebase_workspace, kdepimlibs, kdebase, kdegraphics, kdeedu
, automoc4, phonon, soprano, eigen, qimageblitz, attica}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.4.1";
  src = fetchurl {
    url = mirror://kde/stable/4.4.1/src/kdeplasma-addons-4.4.1.tar.bz2;
    sha256 = "0dgr2n77m60l3vni2f6sk3bspnbkkvnsnd7aq7ql8j1nnm6csqa7";
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
