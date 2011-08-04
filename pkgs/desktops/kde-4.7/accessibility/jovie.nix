{ kde, cmake, qt4, kdelibs, automoc4, phonon }:

kde.package {
  buildInputs = [ cmake qt4 kdelibs automoc4 phonon ];

#TODO: working backend: speechd or opentts
  meta = {
    description = "Text-to-speech synthesis daemon";
    kde = {
      name = "jovie";
      module = "kdeaccessibility";
      version = "0.6.0";
      versionFile = "jovie/jovie/main.cpp";
    };
  };
}

