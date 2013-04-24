{ kde, kdelibs }:

kde {
  name = "kdeartwork-icon-themes";

  # Sources contain primary and kdeclassic as well but they're not installed

  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE nuvola and mono icon themes";
  };
}
