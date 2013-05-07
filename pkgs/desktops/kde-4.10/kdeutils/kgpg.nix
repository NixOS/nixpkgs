{ kde, kdelibs, kdepimlibs }:

kde {
  buildInputs = [ kdelibs kdepimlibs ];

  meta = {
    description = "Simple KDE GUI for GPG";
  };
}
