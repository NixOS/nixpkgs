{ kde, kdelibs, libxml2, libxslt, boost }:

kde {
  buildInputs = [ kdelibs libxml2 libxslt boost ];

  meta = {
    description = "Umbrello UML modeller";
  };
}
