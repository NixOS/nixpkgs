{ kde, kdelibs, speechd }:

kde {
  buildInputs = [ kdelibs speechd ];

  meta = {
    description = "Bridge that provides accessibility services to applications";
  };
}
