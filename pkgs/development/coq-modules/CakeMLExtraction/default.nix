{
  lib,
  mkCoqDerivation,
  coq,
  ceres-bs,
  equations,
  metarocq-erasure-plugin,
  version ? null,
}:

(mkCoqDerivation {
  pname = "CakeMLExtraction";
  owner = "peregrine-project";
  repo = "cakeml-backend";
  opam-name = "rocq-cakeml-extraction";

  inherit version;
  defaultVersion =
    let
      case = coq: mr: out: {
        cases = [
          coq
          mr
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [
        coq.coq-version
        metarocq-erasure-plugin.version
      ]
      [
        (case (range "9.0" "9.1") (range "1.4" "1.5.1") "0.1.0")
      ]
      null;
  release = {
    "0.1.0".sha256 = "sha256-diDUTj0l4vliov9+Lg8lNRdkLE7JAfJn8OU7J/HgmDE=";
  };
  releaseRev = v: "v${v}";

  mlPlugin = false;
  useDune = false;

  buildInputs = [
    equations
    metarocq-erasure-plugin
    ceres-bs
  ];
  propagatedBuildInputs = [ coq.ocamlPackages.findlib ];

  meta = with lib; {
    homepage = "https://peregrine-project.github.io/";
    description = "CakeML backend for Peregrine";
    maintainers = with maintainers; [ _4ever2 ];
  };
})
