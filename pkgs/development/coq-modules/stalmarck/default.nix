{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
  version ? null,
}:

let
  repo = "stalmarck";
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = isEq "8.20";
        out = "8.20.0";
      }
    ] null;
  release = {
    "8.20.0".sha256 = "sha256-jITxQT1jLyZvWCGPnmK8i3IrwsZwMPOV0aBe9r22TIQ=";
  };
  releaseRev = v: "v${v}";

  packages = [
    "stalmarck"
    "stalmarck-tactic"
  ];

  stalmarck_ =
    package:
    let
      pname = package;
      istac = package == "stalmarck-tactic";
      propagatedBuildInputs = if istac then [ (stalmarck_ "stalmarck") ] else [ stdlib ];
      description =
        if istac then
          "Coq tactic and verified tool for proving tautologies using Stålmarck's algorithm"
        else
          "A two-level approach to prove tautologies using Stålmarck's algorithm in Coq.";
    in
    mkCoqDerivation {
      inherit
        version
        pname
        defaultVersion
        release
        releaseRev
        repo
        propagatedBuildInputs
        ;

      mlPlugin = istac;
      useDune = istac;

      meta = {
        inherit description;
        license = lib.licenses.lgpl21Plus;
      };

      passthru = lib.genAttrs packages stalmarck_;
    };
in
stalmarck_ "stalmarck-tactic"
