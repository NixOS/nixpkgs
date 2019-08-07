{ lib, fetchFromGitHub, buildOasisPackage, ounit, minisat, tcslib, ocaml-sat-solvers, num, ocaml_extlib }:

buildOasisPackage rec {
  pname = "pgsolver";
  version = "4.1";

  minimumSupportedOCamlVersion = "4.03.0";

  src = fetchFromGitHub {
    owner  = "tcsprojects";
    repo   = "pgsolver";
    rev    = "v${version}";
    sha256 = "16skrn8qql9djpray25xv66rjgfl20js5wqnxyq1763nmyizyj8a";
  };

  buildInputs = [ ounit ];
  propagatedBuildInputs = [ num tcslib ocaml_extlib ocaml-sat-solvers minisat ];

  meta = {
    homepage = https://github.com/tcsprojects/pgsolver;
    description = "A collection of tools for generating, manipulating and - most of all - solving parity games";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
}
