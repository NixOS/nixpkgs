{ stdenv, fetchurl, lib, cmake, qt4, perl, python, shared_mime_info, libXtst, libXi
, kdelibs, kdebase_workspace, kdepimlibs, kdebase, kdegraphics, kdeedu
, automoc4, phonon, soprano, eigen, qimageblitz, attica}:

stdenv.mkDerivation {
  name = "kdeplasma-addons-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdeplasma-addons-4.4.2.tar.bz2;
    sha256 = "044xfs4j98wgc0zjfxsml7wlydna3h31zdpxnkv178sq592m1pid";
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
