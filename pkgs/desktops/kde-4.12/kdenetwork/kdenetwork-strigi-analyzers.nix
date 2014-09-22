{ kde, kdelibs, boost }:

kde {
  buildInputs = [ kdelibs boost boost.lib ];

  meta = {
    description = "Strigi analyzers for various network protocols";
  };
}
