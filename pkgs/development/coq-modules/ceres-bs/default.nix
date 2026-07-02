{
  lib,
  mkCoqDerivation,
  coq,
  metarocq-utils,
  stdlib,
  version ? null,
}:

mkCoqDerivation {

  pname = "ceres-bs";
  repo = "rocq-ceres-bytestring";
  opam-name = "rocq-ceres-bytestring";
  owner = "peregrine-project";

  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch coq.version [
      (case (range "9.0" "9.1") "1.0.0")
    ] null;
  release."1.0.0".sha256 = "sha256-aB/YWw4E1myIYDRlNs/dEXoI9HDKl1/lsPGMYzjyJsU=";
  releaseRev = v: "v${v}";

  useDune = true;

  propagatedBuildInputs = [
    coq.ocamlPackages.findlib
    stdlib
    metarocq-utils
  ];

  meta = {
    description = "Library for serialization via S-expressions using bytestrings. Alternative to coq-ceres which uses String from standard library.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _4ever2 ];
  };
}
