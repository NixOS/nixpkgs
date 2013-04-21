{ kde, kdelibs, kdepimlibs, nepomuk_core }:

kde {
  buildInputs = [ kdelibs kdepimlibs nepomuk_core ];

  meta = {
    description = "Simple KDE GUI for GPG";
  };
}
