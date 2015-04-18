{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE properties dialog plugin to share a directory with the local network";
  };
}
