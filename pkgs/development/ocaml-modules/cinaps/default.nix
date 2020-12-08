{ lib, buildDunePackage, fetchurl, re, ppx_jane }:

let
  major = "0.14";
in

buildDunePackage rec {
  pname = "cinaps";
  version = "${major}.0";

  minimumOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://ocaml.janestreet.com/ocaml-core/v${major}/files/cinaps-v${version}.tar.gz";
    sha256 = "1zacmcp97c75r03l1p9wpg81qj9g2r52dhiag7xqhn94q33zklcc";
  };

  useDune2 = true;

  propagatedBuildInputs = [ re ];

  doCheck = true;
  checkInputs = [ ppx_jane ];

  meta = with lib; {
    description = "Trivial Metaprogramming tool using the OCaml toplevel";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/ocaml-ppx/cinaps";
  };
}
