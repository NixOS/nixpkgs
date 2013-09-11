{ kde, kdelibs, kdepimlibs, libuuid }:

kde {

# TODO: uuid/uuid.h - not found

  buildInputs = [ kdelibs kdepimlibs libuuid ];

  meta = {
    description = "Simple KDE GUI for GPG";
  };
}
