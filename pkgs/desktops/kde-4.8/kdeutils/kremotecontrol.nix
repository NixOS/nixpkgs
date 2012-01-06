{ kde, kdelibs, kde_workspace, libXtst }:

kde {
  buildInputs = [ kdelibs kde_workspace libXtst ];

  meta = {
    description = "KDE remote control";
  };
}
