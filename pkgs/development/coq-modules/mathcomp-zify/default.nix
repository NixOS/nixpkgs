{
  lib,
  mkCoqDerivation,
  coq,
  mathcomp-boot,
  mathcomp-fingroup,
  mathcomp-algebra,
  stdlib,
  version ? null,
}:

mkCoqDerivation {
  namePrefix = [
    "coq"
    "mathcomp"
  ];
  pname = "zify";
  repo = "mczify";
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
        (case (range "8.16" "9.0") (isGe "2.0.0") "1.5.0+2.0+8.16")
        (case (range "8.13" "8.20") (range "1.12" "1.19.0") "1.3.0+1.12+8.13")
        (case (range "8.13" "8.16") (range "1.12" "1.17.0") "1.1.0+1.12+8.13")
      ]
      null;

  release."1.0.0+1.12+8.13".sha256 = "1j533vx6lacr89bj1bf15l1a0s7rvrx4l00wyjv99aczkfbz6h6k";
  release."1.1.0+1.12+8.13".sha256 = "1plf4v6q5j7wvmd5gsqlpiy0vwlw6hy5daq2x42gqny23w9mi2pr";
  release."1.3.0+1.12+8.13".sha256 = "sha256-ebfY8HatP4te44M6o84DSLpDCkMu4IroPCy+HqzOnTE=";
  release."1.5.0+2.0+8.16".sha256 = "sha256-boBYGvXdGFc6aPnjgSZYSoW4kmN5khtNrSV3DUv9DqM=";

  propagatedBuildInputs = [
    mathcomp-boot
    mathcomp-algebra
    mathcomp-fingroup
    stdlib
  ];

  meta = {
    description = "Micromega tactics for Mathematical Components";
    maintainers = with lib.maintainers; [ cohencyril ];
  };
}
