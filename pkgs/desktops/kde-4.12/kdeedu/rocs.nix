{ kde, kdelibs, boost, grantlee }:

kde {
  buildInputs = [ kdelibs (boost.override { enableExceptions = true; }) grantlee ];

  NIX_CFLAGS_COMPILE = "-fexceptions";

  meta = {
    description = "A KDE graph theory viewer";
    kde = {
      name = "rocs";
    };
  };
}
