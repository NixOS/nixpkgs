{ kde, kdelibs, boost, grantlee }:
let
  boostpkg = boost.override { enableExceptions = true; };
in
kde {
  buildInputs = [ kdelibs boostpkg boostpkg.lib grantlee ];

  NIX_CFLAGS_COMPILE = "-fexceptions";

  meta = {
    description = "A KDE graph theory viewer";
    kde = {
      name = "rocs";
    };
  };
}
