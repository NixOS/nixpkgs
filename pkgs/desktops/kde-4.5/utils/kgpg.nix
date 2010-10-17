{ kde, cmake, kdelibs, qt4, perl, automoc4, kdepimlibs }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 kdepimlibs ];

  meta = {
    description = "Simple KDE GUI for gpg";
    kde = {
      name = "kgpg";
      module = "kdeutils";
      version = "2.4.1";
      release = "4.5.2";
      versionFile = "main.cpp";
    };
  };
}
