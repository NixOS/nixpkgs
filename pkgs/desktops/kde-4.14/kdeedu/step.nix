{ kde, kdelibs, gsl, libqalculate, eigen, pkgconfig }:

kde {

  buildInputs = [ kdelibs gsl libqalculate eigen ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "A KDE interactive physical simulator";
  };
}
