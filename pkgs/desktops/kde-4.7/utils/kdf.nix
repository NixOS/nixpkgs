{ kde, cmake, kdelibs, qt4, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

  meta = {
    description = "KDE free disk space utility";
    kde = {
      name = "kdf";
      module = "kdeutils";
      version = "0.13";
      versionFile = "kdf.cpp";
    };
  };
}
