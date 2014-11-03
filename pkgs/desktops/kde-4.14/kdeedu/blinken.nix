{ kde, kdelibs }:
kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Memory Enhancement Game";
  };
}
