{ kde, cmake, kdelibs, qt4, perl, automoc4, shared_mime_info, qca2 }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 shared_mime_info qca2 ];

  meta = {
    description = "KDE byte editor";
    kde = {
      name = "okteta";
      module = "kdeutils";
      version = "0.5.2";
      release = "4.5.2";
      versionFile = "program/about.cpp";
    };
  };
}
