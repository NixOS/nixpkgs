{ kde, kdelibs, gsl, libqalculate, eigen2, pkgconfig }:

kde {

  buildInputs = [ kdelibs gsl libqalculate eigen2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "A KDE interactive physical simulator";
  };
}
