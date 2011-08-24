{ kde, kdelibs, libxml2, libxslt }:

kde {
  buildInputs = [ kdelibs libxml2 libxslt ];

  meta = {
    description = "A graphical editor of scripted dialogs";
  };
}
