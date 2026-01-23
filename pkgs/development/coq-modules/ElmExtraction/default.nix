{
  lib,
  mkCoqDerivation,
  which,
  coq,
  metacoq,
  version ? null,
}:

mkCoqDerivation {
  pname = "ElmExtraction";
  repo = "coq-elm-extraction";
  owner = "AU-COBRA";
  domain = "github.com";

  inherit version;
  defaultVersion =
    let
      case = coq: mc: out: {
        cases = [
          coq
          mc
        ];
        inherit out;
      };
    in
    lib.switch
      [
        coq.coq-version
        metacoq.version
      ]
      [
        (case (lib.versions.range "8.17" "9.0") (lib.versions.range "1.3.1" "1.3.4") "0.1.1")
      ]
      null;

  release."0.1.0".sha256 = "EWjubBHsxAl2HuRAfJI3B9qzP2mj89eh0CUc8y7/7Ds=";
  release."0.1.1".sha256 = "SDSyXqtOQlW9m9yH8OC909fsC/ePhKkSiY+BoQE76vk=";

  releaseRev = v: "v${v}";

  propagatedBuildInputs = [
    coq.ocamlPackages.findlib
    metacoq
  ];

  postPatch = "patchShebangs ./tests/process-extraction-examples.sh";

  meta = {
    description = "Framework for extracting Coq programs to Elm";
    maintainers = with lib.maintainers; [ _4ever2 ];
    license = lib.licenses.mit;
  };
}
