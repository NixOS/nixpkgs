{ lib, fetchFromGitHub, buildOasisPackage, ounit, tcslib, ocaml-sat-solvers }:

buildOasisPackage rec {
  pname = "pgsolver";
  version = "4.1";

  src = fetchFromGitHub {
    owner  = "tcsprojects";
    repo   = "pgsolver";
    rev    = "v${version}";
    sha256 = "16skrn8qql9djpray25xv66rjgfl20js5wqnxyq1763nmyizyj8a";
  };

  buildInputs = [ ounit ];
  propagatedBuildInputs = [ tcslib ocaml-sat-solvers ];

  meta = {
    description = "A collection of tools for generating, manipulating and - most of all - solving parity games";
    homepage = "https://github.com/tcsprojects/pgsolver";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mgttlinger ];
    mainProgram = "pgsolver-bin";
  };
}
