{ lib, fetchFromGitHub, ocamlPackages, buildOasisPackage, ounit, ocaml_extlib, num }:

buildOasisPackage rec {
  pname = "tcslib";
  version = "0.3";

  minimumOCamlVersion = "4.03.0";

  src = fetchFromGitHub {
    owner  = "tcsprojects";
    repo   = "tcslib";
    rev    = "v${version}";
    sha256 = "05g6m82blsccq8wx8knxv6a5fzww7hi624jx91f9h87nk2fsplhi";
  };

  buildInputs = [ ounit ];
  propagatedBuildInputs = [ ocaml_extlib num ];

  meta = {
    homepage = "https://github.com/tcsprojects/tcslib";
    description = "A multi-purpose library for OCaml";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
}
