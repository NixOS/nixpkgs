{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
  version ? null,
}:
let
  MenhirLib = mkCoqDerivation {
    pname = "MenhirLib";
    owner = "fpottier";
    repo = "menhir";
    domain = "gitlab.inria.fr";
    inherit version;
    defaultVersion =
      let
        case = case: out: { inherit case out; };
      in
      with lib.versions;
      lib.switch coq.coq-version [
        (case (range "8.12" "9.1") "20250903")
        (case (range "8.7" "8.11") "20200624")
      ] null;
    release = {
      "20250903".sha256 = "sha256-ap1OvcvCAuqmFDwhPwMBosHs3cm5NxPW/w1J8AzWduk=";
      "20240715".sha256 = "sha256-9CSxAIm0aEXkwF+aj8u/bqLG30y5eDNz65EnohJPjzI="; # coq 8.9 - 8.20
      "20231231".sha256 = "sha256-veB0ORHp6jdRwCyDDAfc7a7ov8sOeHUmiELdOFf/QYk="; # coq 8.7 - 8.19
      "20230608".sha256 = "sha256-dUPoIUVr3gqvE5bniyQh/b37tNfRsZN8X3e99GFkyLY="; # coq 8.7 - 8.18
      "20230415".sha256 = "sha256-WjE3iOKlUb15MDG3+GOi+nertAw9L2Ryazi/0JEvjqc="; # coq 8.7 - 8.18
      "20220210".sha256 = "sha256-Nljrgq8iW17qbn2PLIbjPd03WCcZm08d1DF6NrKOYTg="; # coq 8.7 - 8.18
      "20211230".sha256 = "sha256-+ntl4ykkqJWEeJJzt6fO5r0X1J+4in2LJIj1N8R175w="; # coq 8.7 - 8.18
      "20200624".sha256 = "sha256-8lMqwmOsqxU/45Xr+GeyU2aIjrClVdv3VamCCkF76jY="; # coq 8.7 - 8.13
    };
    propagatedBuildInputs = [ stdlib ];
    preBuild = "cd coq-menhirlib/src";
    meta = {
      homepage = "https://gitlab.inria.fr/fpottier/menhir/-/tree/master/coq-menhirlib";
      description = "Support library for verified Coq parsers produced by Menhir";
      license = lib.licenses.lgpl3Plus;
      maintainers = with lib.maintainers; [ damhiya ];
    };
  };
in
MenhirLib.overrideAttrs (
  oldAttrs:
  if oldAttrs.version <= "20211230" then
    { installPhase = "make TARGET=$out/lib/coq/${coq.coq-version}/user-contrib/MenhirLib install"; }
  else
    { }
)
