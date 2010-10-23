{ kde, cmake, qt4, perl, automoc4, kdelibs }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

  meta = {
    description = "KDE Accessibility color schemes";
    kde = {
      name = "ColorSchemes";
      module = "kdeaccessibility";
      version = "4.5.2";
    };
  };
}
