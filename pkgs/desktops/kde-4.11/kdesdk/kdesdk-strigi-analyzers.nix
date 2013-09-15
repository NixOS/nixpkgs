{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Strigi analyzers for diff, po and ts";
  };
}
