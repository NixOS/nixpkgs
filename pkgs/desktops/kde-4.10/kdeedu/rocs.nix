{ kde, kdelibs, boost }:

kde {
  buildInputs = [ kdelibs (boost.override { enableExceptions = true; }) ];

  NIX_CFLAGS_COMPILE = "-fexceptions";

  meta = {
    description = "A KDE graph theory viewer";
    kde = {
      name = "rocs";
    };
  };
}
