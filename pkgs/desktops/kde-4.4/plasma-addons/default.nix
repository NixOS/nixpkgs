{ stdenv, fetchurl, lib, cmake, qt4, perl, python, shared_mime_info, libXtst, libXi
, kdelibs, kdebase_workspace, kdepimlibs, kdebase, kdegraphics, kdeedu
, automoc4, phonon, soprano, eigen, qimageblitz, attica, qca2}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdeplasma-addons-4.4.5.tar.bz2;
    sha256 = "1wrgnfag4bn27kii3rzrzadw0xc869miml0kxsxcj9ryqppxbfxd";
  };
  inherit kdebase_workspace;
  builder = ./builder.sh;
  KDEDIRS="${kdeedu}";
  buildInputs = [ cmake qt4 perl python shared_mime_info libXtst libXi
                  kdelibs kdebase_workspace kdepimlibs kdebase kdegraphics kdeedu
		  automoc4 qca2 phonon soprano eigen qimageblitz attica ];
  meta = {
    description = "KDE Plasma Addons";
    license = "GPL";
    homepage = http://www.kde.org;
    inherit (kdelibs.meta) maintainers platforms;
  };
}
