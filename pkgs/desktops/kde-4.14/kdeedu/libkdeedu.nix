{ kde, kdelibs }:
kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Libraries used by KDE Education applications";
  };
}
