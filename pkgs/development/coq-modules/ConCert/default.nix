{
  lib,
  mkCoqDerivation,
  which,
  coq,
  metarocq-erasure,
  bignums,
  QuickChick,
  stdpp,
  TypedExtraction,
  version ? null,
}:

with lib;
mkCoqDerivation {
  pname = "ConCert";
  repo = "ConCert";
  owner = "AU-COBRA";
  domain = "github.com";

  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in

    lib.switch coq.coq-version [
      (case "9.1" "1.0.1")
    ] null;
  release."1.0.1".sha256 = "sha256-HqbgUnGcZHkeG6qLf4qp/JT5oTPmdfOn1IJqnrloM2U=";
  release."1.0.0".sha256 = "sha256-R+kWOZtR7T2LVQnHmLGDmGpLO0S76fPRWJpsO9nWqLE=";
  releaseRev = v: "v${v}";

  propagatedBuildInputs = [
    coq.ocamlPackages.findlib
    metarocq-erasure
    bignums
    QuickChick
    stdpp
    TypedExtraction
  ];

  postPatch = "patchShebangs ./extraction/process-extraction-examples.sh";

  buildPhase = ''
    make core
  '';

  meta = {
    description = "A framework for smart contract verification in Rocq";
    maintainers = with maintainers; [ _4ever2 ];
    license = licenses.mit;
  };
}
