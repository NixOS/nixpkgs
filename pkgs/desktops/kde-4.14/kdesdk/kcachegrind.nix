{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "KDE Frontend for Callgrind/Cachegrind";
  };
}
