{ kde, kdelibs, kdepimlibs, boost }:

kde {

  buildInputs = [ kdelibs kdepimlibs boost ];

  meta = {
    description = "Simple KDE GUI for GPG";
  };
}
