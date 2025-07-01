{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp-ssreflect,
  mathcomp-algebra,
  coq-elpi,
  mathcomp-zify,
  version ? null,
}:

mkCoqDerivation {
  namePrefix = [
    "coq"
    "mathcomp"
  ];
  pname = "algebra-tactics";
  owner = "math-comp";
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
      [ coq.coq-version mathcomp-algebra.version ]
      [
        (case (range "8.20" "9.0") (isGe "2.4") "1.2.5")
        (case (range "8.16" "9.0") (isGe "2.0") "1.2.4")
        (case (range "8.16" "8.18") (isGe "2.0") "1.2.2")
        (case (range "8.16" "8.19") (isGe "1.15") "1.1.1")
        (case (range "8.13" "8.16") (isGe "1.12") "1.0.0")
      ]
      null;

  release."1.0.0".sha256 = "sha256-kszARPBizWbxSQ/Iqpf2vLbxYc6AjpUCLnSNlPcNfls=";
  release."1.1.1".sha256 = "sha256-5wItMeeTRoJlRBH3zBNc2VUZn6pkDde60YAvXTx+J3U=";
  release."1.2.2".sha256 = "sha256-EU9RJGV3BvnmsX+mGH+6+MDXiGHgDI7aP5sIYiMUXTs=";
  release."1.2.3".sha256 = "sha256-6uc1VEfDv+fExEfBR2c0/Q/KjrkX0TbEMCLgeYcpkls=";
  release."1.2.4".sha256 = "sha256-BRxt0LGPz2u3kJRjcderaZqCfs8M8qKAAwNSWmIck7Q=";
  release."1.2.5".sha256 = "sha256-wTfe+g7ljWs1S+g02VQutnJGLVIOzNX1lm1HTMXeUUA=";

  propagatedBuildInputs = [
    mathcomp-ssreflect
    mathcomp-algebra
    coq-elpi
    mathcomp-zify
  ];

  meta = {
    description = "Ring and field tactics for Mathematical Components";
    maintainers = with lib.maintainers; [ cohencyril ];
  };
}
