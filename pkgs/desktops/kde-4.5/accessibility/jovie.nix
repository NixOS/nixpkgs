{ kde, cmake, qt4, perl, automoc4, kdelibs }:

kde.package {
  buildInputs = [ cmake qt4 perl kdelibs automoc4 ];

#TODO: working backend: speechd or opentts
  meta = {
    description = "Text-to-speech synthesis daemon";
    kde = {
      name = "jovie";
      module = "kdeaccessibility";
      version = "0.6.0";
      release = "4.5.1";
    };
  };
}

