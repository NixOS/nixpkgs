{ kde, kdelibs, kdepimlibs, boost }:

kde {

  buildInputs = [ kdelibs kdepimlibs boost boost.lib ];

  meta = {
    description = "Simple KDE GUI for GPG";
  };
}
