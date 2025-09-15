{
  lib,
  mkCoqDerivation,
  callPackage,
  coq,
  flocq,
  parseque,
  mathcomp-boot,
  compcert,
  ExtLib,
  version ? null,
}:

with lib;
mkCoqDerivation {
  pname = "wasm";
  repo = "WasmCert-Coq";
  owner = "WasmCert";

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
    with lib.versions;
    lib.switch
      [ coq.coq-version mathcomp-boot.version ]
      [
        (case (isEq "8.20") (isEq "2.4") "2.2.0")
      ]
      null;

  release."2.1.0".sha256 = "sha256-k094mxDLLeelYP+ABm+dm6Y5YrachrbhNeZhfwLHNRo=";
  release."2.2.0".sha256 = "sha256-GsfNpXgCG6XGqDE+bekzwZsWIHyjDTzWRuNnjCtS/88=";

  mlPlugin = true;
  useDune = true;

  propagatedBuildInputs = [
    ExtLib
    mathcomp-boot
    parseque
    flocq
    compcert
  ];

  buildInputs = [
    coq.ocamlPackages.mdx
    coq.ocamlPackages.linenoise
    coq.ocamlPackages.wasm
  ];

  releaseRev = v: "v${v}";

  passthru.tests.HelloWorld = callPackage ./test.nix { };

  meta = {
    description = "Wasm mechanisation in Coq/Rocq";
    maintainers = with maintainers; [ womeier ];
    license = licenses.mit;
  };
}
