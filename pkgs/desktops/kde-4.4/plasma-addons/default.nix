{ stdenv, fetchurl, lib, cmake, qt4, perl, python, shared_mime_info, libXtst, libXi
, kdelibs, kdebase_workspace, kdepimlibs, kdebase, kdegraphics, kdeedu
, automoc4, phonon, soprano, eigen, qimageblitz, attica}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdeplasma-addons-4.4.3.tar.bz2;
    sha256 = "00pr74x0q88wn7a4v6m35djcd29yw870fd6dgklqp1zs5yrn0p97";
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
