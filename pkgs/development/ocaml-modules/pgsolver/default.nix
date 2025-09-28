{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildOasisPackage,
  ounit,
  tcslib,
  ocaml-sat-solvers,
}:

buildOasisPackage rec {
  pname = "pgsolver";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "tcsprojects";
    repo = "pgsolver";
    rev = "v${version}";
    sha256 = "16skrn8qql9djpray25xv66rjgfl20js5wqnxyq1763nmyizyj8a";
  };

  # Compatibility with ocaml-sat-solvers 0.8
  patches = fetchpatch {
    url = "https://github.com/tcsprojects/pgsolver/commit/e57a4fc5c8050b8d4ada5583a6c65ecf8cd65141.patch";
    hash = "sha256-QFKxWByptnCl1SfleNASyXmKM2gkh1OE66L8PAZX+TU=";
    includes = [
      "src/solvers/*.ml"
      "src/tools/*.ml"
    ];
  };

  buildInputs = [ ounit ];
  propagatedBuildInputs = [
    tcslib
    ocaml-sat-solvers
  ];

  meta = {
    description = "Collection of tools for generating, manipulating and - most of all - solving parity games";
    homepage = "https://github.com/tcsprojects/pgsolver";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mgttlinger ];
    mainProgram = "pgsolver-bin";
  };
}
