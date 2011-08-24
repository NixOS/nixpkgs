{ kde, kdelibs }:

kde {
  buildInputs = [ kdelibs ];

  meta = {
    description = "Strigi analyzers for various graphics file formats";
    license = "GPLv2";
  };
}
