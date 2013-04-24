{ kde, kdelibs, taglib }:
kde {
  buildInputs = [ kdelibs taglib ];
  meta = {
    description = "an audio jukebox application";
  };
}
