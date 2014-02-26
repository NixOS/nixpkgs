{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "A type-and-say front end for speech synthesizers";
  };
}
