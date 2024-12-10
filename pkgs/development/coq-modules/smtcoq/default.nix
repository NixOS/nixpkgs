{
  lib,
  stdenv,
  pkgs,
  mkCoqDerivation,
  coq,
  trakt,
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

  release."SMTCoq-2.1+8.16".rev = "4996c00b455bfe98400e96c954839ceea93efdf7";
  release."SMTCoq-2.1+8.16".sha256 = "sha256-k53e+frUjwq+ZZKbbOKd/EfVC40QeAzB2nCsGkCKnHA=";
  release."SMTCoq-2.1+8.14".rev = "e11d9b424b0113f32265bcef0ddc962361da4dae";
  release."SMTCoq-2.1+8.14".sha256 = "sha256-4a01/CRHUon2OfpagAnMaEVkBFipPX3MCVmSFS1Bnt4=";
  release."SMTCoq-2.1+8.13".rev = "d02269c43739f4559d83873563ca00daad9faaf1";
  release."SMTCoq-2.1+8.13".sha256 = "sha256-VZetGghdr5uJWDwZWSlhYScoNEoRHIbwqwJKSQyfKKg=";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = isEq "8.16";
        out = "SMTCoq-2.1+8.16";
      }
      {
        case = isEq "8.14";
        out = "SMTCoq-2.1+8.14";
      }
      {
        case = isEq "8.13";
        out = "SMTCoq-2.1+8.13";
      }
    ] null;

  propagatedBuildInputs =
    [
      trakt
      cvc5
      veriT'
      zchaff
    ]
    ++ (with coq.ocamlPackages; [
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
