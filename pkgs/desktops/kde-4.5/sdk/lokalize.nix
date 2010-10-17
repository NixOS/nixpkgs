{ kde, cmake, kdelibs, automoc4, hunspell }:

kde.package {
  buildInputs = [ cmake kdelibs automoc4 hunspell ];


  meta = {
    description = "KDE 4 Computer-aided translation system";
    longDescription = ''
      Computer-aided translation system.
      Do not translate what had already been translated.'';
    kde = {
      name = "lokalize";
      module = "kdesdk";
      version = "1.1";
      release = "4.5.2";
      versionFile = "src/version.h";
    };
  };
}
