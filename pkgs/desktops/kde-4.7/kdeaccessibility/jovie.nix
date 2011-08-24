{ kde, kdelibs, speechd }:

kde {
  buildInputs = [ kdelibs speechd ];

  meta = {
    description = "Text-to-speech synthesis daemon";
  };
}
