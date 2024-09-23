{ lib, buildDunePackage, fetchFromGitLab, ppxlib, ppx_deriving, result }:

buildDunePackage rec {
  pname = "visitors";
  version = "20210608";

  duneVersion = "3";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitLab {
    owner = "fpottier";
    repo = pname;
    rev = version;
    domain = "gitlab.inria.fr";
    sha256 = "1p75x5yqwbwv8yb2gz15rfl3znipy59r45d1f4vcjdghhjws6q2a";
  };

  propagatedBuildInputs = [ ppxlib ppx_deriving result ];

  meta = with lib; {
    homepage = "https://gitlab.inria.fr/fpottier/visitors";
    changelog = "https://gitlab.inria.fr/fpottier/visitors/-/raw/${version}/CHANGES.md";
    license = licenses.lgpl21;
    description = "OCaml syntax extension (technically, a ppx_deriving plugin) which generates object-oriented visitors for traversing and transforming data structures";
    maintainers = [ ];
  };
}
