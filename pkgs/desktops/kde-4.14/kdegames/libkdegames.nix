{ kde, kdelibs, openal, libsndfile }:
kde {
  buildInputs = [ kdelibs openal libsndfile ];
  meta = {
    description = "KDE games library";
  };
}
