{ kde, cmake, kdelibs, qt4, libarchive, xz, automoc4
, phonon, bzip2, kde_baseapps }:

kde.package {
  buildInputs =
    [ cmake kdelibs qt4 automoc4 phonon kde_baseapps
      libarchive xz bzip2
    ];

  meta = {
    description = "KDE Archiving Tool";
    kde = {
      name = "ark";
      module = "kdeutils";
      version = "2.17";
      versionFile = "app/main.cpp";
    };
  };
}
