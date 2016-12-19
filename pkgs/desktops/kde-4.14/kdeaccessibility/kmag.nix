{ kde, kdelibs }:

kde {
#todo: package qaccessibilityclient
  buildInputs = [ kdelibs ];

  meta = {
    description = "Screen magnifier for KDE";
  };
}
