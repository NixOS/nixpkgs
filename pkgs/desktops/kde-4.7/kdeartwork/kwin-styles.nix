{ kde, kdelibs, kde_workspace }:

kde {
  buildInputs = [ kdelibs kde_workspace ];

  meta = {
    description = "Styles for KWin";
  };
}
