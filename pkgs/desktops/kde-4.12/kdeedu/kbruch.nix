{ kde, kdelibs }:
kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Practice Fractions";
  };
}
