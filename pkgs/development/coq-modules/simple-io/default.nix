{ lib, mkCoqDerivation, coq, coq-ext-lib, version ? null }:

with lib; mkCoqDerivation {
  pname = "simple-io";
  owner = "Lysxia";
  repo = "coq-simple-io";
  inherit version;
  defaultVersion = if versions.range "8.7" "8.13" coq.coq-version then "1.3.0" else null;
  release."1.3.0".sha256 = "1yp7ca36jyl9kz35ghxig45x6cd0bny2bpmy058359p94wc617ax";
  extraNativeBuildInputs = (with coq.ocamlPackages; [ ocaml ocamlbuild ]);
  propagatedBuildInputs = [ coq-ext-lib ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "Purely functional IO for Coq";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
