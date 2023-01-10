{ lib, stdenv, gcc10StdenvCompat, pkgs, mkCoqDerivation, coq, trakt, veriT, zchaff, fetchurl, version ? null }:
with lib;

let
  # version of veriT that works with SMTCoq
  veriT' = veriT.overrideAttrs (oA: {
    src = fetchurl {
      url = "https://www.lri.fr/~keller/Documents-recherche/Smtcoq/veriT9f48a98.tar.gz";
      sha256 = "sha256-Pe46PxQVHWwWwx5Ei4Bl95A0otCiXZuUZ2nXuZPYnhY=";
    };
    meta.broken = false;
  });
  cvc4 = pkgs.callPackage ./cvc4.nix {
    stdenv = gcc10StdenvCompat;
  };
in

mkCoqDerivation {
  pname = "smtcoq";
  owner = "smtcoq";

  release."2021-09-17".rev    = "f36bf11e994cc269c2ec92b061b082e3516f472f";
  release."2021-09-17".sha256 = "sha256-bF7ES+tXraaAJwVEwAMx3CUESpNlAUerQjr4d2eaGJQ=";

  inherit version;
  defaultVersion = with versions; switch coq.version [
    { case = isEq "8.13"; out = "2021-09-17"; }
  ] null;

  propagatedBuildInputs = [ trakt cvc4 veriT' zchaff ] ++ (with coq.ocamlPackages; [ num zarith ]);
  mlPlugin = true;
  nativeBuildInputs = (with pkgs; [ gnumake42 ]) ++ (with coq.ocamlPackages; [ ocamlbuild ]);

  # This is meant to ease future troubleshooting of cvc4 build failures
  passthru = { inherit cvc4; };

  meta = {
    description = "Communication between Coq and SAT/SMT solvers ";
    maintainers = with maintainers; [ siraben ];
    license = licenses.cecill-b;
    platforms = platforms.unix;
  };
}
