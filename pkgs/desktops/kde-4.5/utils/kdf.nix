{ kde, cmake, kdelibs, qt4, perl, automoc4 }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

  meta = {
    description = "KDE free disk space utility";
    kde = {
      name = "kdf";
      module = "kdeutils";
      version = "0.11";
      versionFile = "kdf.cpp";
    };
  };
}
