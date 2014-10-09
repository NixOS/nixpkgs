{ kde, kdelibs, libxml2, libxslt, boost }:

kde {
  buildInputs = [ kdelibs libxml2 libxslt boost boost.lib ];

  meta = {
    description = "Umbrello UML modeller";
  };
}
