{ kde, cmake, kdelibs, qt4, perl, libarchive, xz, automoc4, qjson,
  kdebase }:

kde.package {
  patchPhase = "cp -vn ${qjson}/share/apps/cmake/modules/FindQJSON.cmake cmake/modules";

  buildInputs = [ cmake qt4 perl libarchive xz kdelibs automoc4 qjson
    kdebase # for libkonq
    ];

  meta = {
    description = "KDE Archiving Tool";
    kde = {
      name = "ark";
      module = "kdeutils";
      version = "2.15";
      release = "4.5.1";
    };
  };
}
