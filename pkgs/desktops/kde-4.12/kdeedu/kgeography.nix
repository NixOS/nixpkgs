{ kde, kdelibs }:
kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Geography Trainer";
  };
}
