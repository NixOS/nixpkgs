{ kde, cmake, qt4, perl, automoc4, kdelibs }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

  meta = {
    description = "KDE mono icon theme";
    kde = {
      name = "IconThemes";
      module = "kdeaccessibility";
      version = "4.5.2";
    };
  };
}

