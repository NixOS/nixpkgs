{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE tool that monitors the network for DNS-SD services";
  };
}
