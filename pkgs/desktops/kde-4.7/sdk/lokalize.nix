{ kde, cmake, kdelibs, qt4, automoc4, phonon, strigi, hunspell }:

kde.package {
  buildInputs = [ cmake kdelibs qt4 automoc4 phonon strigi hunspell ];

  meta = {
    description = "KDE 4 Computer-aided translation system";
    longDescription = ''
      Computer-aided translation system.
      Do not translate what had already been translated.
    '';
    kde = {
      name = "lokalize";
      module = "kdesdk";
      version = "1.2";
      versionFile = "src/version.h";
    };
  };
}
