{ lib, fetchurl, buildDunePackage, ppxlib, ppx_repr }:

buildDunePackage rec {
  pname = "ppx_irmin";
  version = "2.5.1";

  src = fetchurl {
    url = "https://github.com/mirage/irmin/releases/download/${version}/irmin-${version}.tbz";
    sha256 = "131pcgmpys6danprcbxzf4pdsl0ka74bpmmxz8db4507cvxhsz3n";
  };

  minimumOCamlVersion = "4.08";

  useDune2 = true;

  propagatedBuildInputs = [
    ppx_repr
    ppxlib
  ];

  meta = {
    homepage = "https://irmin.org/";
    description = "PPX deriver for Irmin generics";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ vbgl sternenseemann ];
  };
}
