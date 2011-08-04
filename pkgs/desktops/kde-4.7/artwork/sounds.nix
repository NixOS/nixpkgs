{ cmake, kde, qt4, automoc4, kdelibs, phonon }:

kde.package rec {
  name = "kde-sounds-${kde.release}";

  buildInputs = [ cmake qt4 automoc4 kdelibs phonon ];

  meta = {
    description = "New login/logout sounds";
    kde = {
      name = "sounds";
      module = "kdeartwork";
    };
  };
}
