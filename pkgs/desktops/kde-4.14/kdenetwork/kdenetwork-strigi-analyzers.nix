{ kde, kdelibs, boost }:

kde {
  buildInputs = [ kdelibs boost ];

  meta = {
    description = "Strigi analyzers for various network protocols";
  };
}
