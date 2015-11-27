{ build-idris-package, fetchgit, prelude, base }: build-idris-package (args : {
  name = "wl-pprint";

  src = fetchgit {
    url = "git://github.com/shayan-najd/wl-pprint.git";
    rev = "120f654b0b9838b57e10b163d3562d959439fb07";
    sha256 = "b5d02a9191973dd8915279e84a9b4df430eb252f429327f45eb8a047d8bb954d";
  };

  propagatedBuildInputs = [ prelude base ];
})
