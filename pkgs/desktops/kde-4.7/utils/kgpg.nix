{ kde, cmake, kdelibs, qt4, automoc4, phonon, kdepimlibs }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon kdepimlibs ];

  meta = {
    description = "Simple KDE GUI for GPG";
    kde = {
      name = "kgpg";
      module = "kdeutils";
      version = "2.4.1";
      versionFile = "main.cpp";
    };
  };
}
