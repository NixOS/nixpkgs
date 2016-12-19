{ kde, kdelibs, boost, grantlee }:

kde {
  patches = [ ../files/rocs-0001-duplicate-add_test.patch ];

  buildInputs = [ kdelibs (boost.override { enableExceptions = true; }) grantlee ];

  NIX_CFLAGS_COMPILE = "-fexceptions";

  meta = {
    description = "A KDE graph theory viewer";
    kde = {
      name = "rocs";
    };
  };
}
