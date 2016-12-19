{ kde, kdelibs, kdepimlibs, boost, gpgme }:

kde {

  buildInputs = [ kdelibs kdepimlibs boost gpgme ];

  meta = {
    description = "Simple KDE GUI for GPG";
  };
}
