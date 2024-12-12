{
  lib,
  pkgs,
  mkCoqDerivation,
  coq,
  veriT,
  zchaff,
  fetchurl,
  cvc5,
  version ? null,
}:

let
  # version of veriT that works with SMTCoq
  veriT' = veriT.overrideAttrs (oA: {
    src = fetchurl {
      url = "https://www.lri.fr/~keller/Documents-recherche/Smtcoq/veriT9f48a98.tar.gz";
      sha256 = "sha256-Pe46PxQVHWwWwx5Ei4Bl95A0otCiXZuUZ2nXuZPYnhY=";
    };
    meta.broken = false;
  });
in

mkCoqDerivation {
  pname = "smtcoq";
  owner = "smtcoq";

  release."SMTCoq-2.2+8.19".sha256 = "sha256-9Wv8AXRRyOHG/cjA/V9tSK55R/bofDMLTkDpuwYWkks=";
  release."SMTCoq-2.2+8.18".sha256 = "sha256-1iJAruI5Qn9nTZcUDjk8t/1Q+eFkYLOe9Ee0DmK03w8=";
  release."SMTCoq-2.2+8.17".sha256 = "sha256-kaodsyVUl1+QQagzoBTIjxbdD4X3IaaH0x2AsVUL+Z0=";
  release."SMTCoq-2.2+8.16".sha256 = "sha256-Hwm8IFlw97YiOY6H63HyJlwIXvQHr9lqc1+PgTnBtkw=";
  release."SMTCoq-2.2+8.15".sha256 = "sha256-+GYOasJ32KJyOfqJlTtFmsJ2exd6gdueKwHdeMPErTo=";
  release."SMTCoq-2.2+8.14".sha256 = "sha256-jqnF33E/4CqR1HSrLmUmLVCKslw9h3bbWi4YFmFYrhY=";
  release."SMTCoq-2.2+8.13".sha256 = "sha256-AVpKU/SLaLYnCnx6GOEPGJjwbRrp28Fs5O50kJqdclI=";
  release."SMTCoq-2.1+8.16".rev = "4996c00b455bfe98400e96c954839ceea93efdf7";
  release."SMTCoq-2.1+8.16".sha256 = "sha256-k53e+frUjwq+ZZKbbOKd/EfVC40QeAzB2nCsGkCKnHA=";
  release."SMTCoq-2.1+8.14".rev = "e11d9b424b0113f32265bcef0ddc962361da4dae";
  release."SMTCoq-2.1+8.14".sha256 = "sha256-4a01/CRHUon2OfpagAnMaEVkBFipPX3MCVmSFS1Bnt4=";
  release."SMTCoq-2.1+8.13".rev = "d02269c43739f4559d83873563ca00daad9faaf1";
  release."SMTCoq-2.1+8.13".sha256 = "sha256-VZetGghdr5uJWDwZWSlhYScoNEoRHIbwqwJKSQyfKKg=";

  releaseRev = v: v;

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = isEq "8.19";
        out = "SMTCoq-2.2+8.19";
      }
      {
        case = isEq "8.18";
        out = "SMTCoq-2.2+8.18";
      }
      {
        case = isEq "8.17";
        out = "SMTCoq-2.2+8.17";
      }
      {
        case = isEq "8.16";
        out = "SMTCoq-2.2+8.16";
      }
      {
        case = isEq "8.15";
        out = "SMTCoq-2.2+8.15";
      }
      {
        case = isEq "8.14";
        out = "SMTCoq-2.2+8.14";
      }
      {
        case = isEq "8.13";
        out = "SMTCoq-2.2+8.13";
      }
    ] null;

  propagatedBuildInputs =
    [
      cvc5
      veriT'
      zchaff
    ]
    ++ (with coq.ocamlPackages; [
      findlib
      num
      zarith
    ]);
  mlPlugin = true;
  nativeBuildInputs = (with pkgs; [ gnumake42 ]) ++ (with coq.ocamlPackages; [ ocamlbuild ]);

  # This is meant to ease future troubleshooting of cvc5 build failures
  passthru = { inherit cvc5; };

  meta = with lib; {
    description = "Communication between Coq and SAT/SMT solvers";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
