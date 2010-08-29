{ stdenv, fetchurl, cmake, qt4, perl, gmp, python, libarchive, xz
, sip, pyqt4, pycups, rhpl, system_config_printer, qjson, shared_mime_info
, kdebase_workspace
, kdelibs, kdepimlibs, kdebase, kdebindings, automoc4, qimageblitz, qca2}:

let
  src = fetchurl {
    url = mirror://kde/stable/src/kdeutils-4.5.0.tar.bz2;
    sha256 = "1x4dwc193gsfcnryhkv2v3xafjr1a87ls0zfi56i1w2aj38b36l7";
  };
in
{
  ark = kdeSplitPackage
 {
  name = "ark-2.15";

  inherit src;

  patchPhase = "cp -vn ${qjson}/share/apps/cmake/modules/FindQJSON.cmake cmake/modules";

  buildInputs = [ cmake qt4 perl libarchive xz kdelibs automoc4 qjson
    kdebase # for libkonq
    ];

  cmakeFlags = "-DDISABLE_ALL_OPTIONAL_SUBDIRECTORIES=TRUE -DBUILD_doc=TRUE -DBUILD_ark=TRUE";
}
  kcalc = callPackage ./kcalc.nix { inherit src; };
}
