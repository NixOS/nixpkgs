{ kde, kdelibs, libtiff }:

kde {
  buildInputs = [ kdelibs libtiff ];

  meta = {
    description = "Strigi analyzers for various graphics file formats";
    license = "GPLv2";
  };
}
