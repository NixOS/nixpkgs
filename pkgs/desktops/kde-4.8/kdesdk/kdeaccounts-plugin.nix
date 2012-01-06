{ kde, kdelibs, kdepimlibs }:

kde {
  buildInputs = [ kdelibs kdepimlibs ];

  meta = {
    description = "KDE accounts akonadi agent";
  };
}
