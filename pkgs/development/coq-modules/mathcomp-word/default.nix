{ fetchurl, coq, mkCoqDerivation, mathcomp, lib, version ? null }:

let
  namePrefix = [ "coq" "mathcomp" ];
  pname = "word";
  fetcher = { domain, owner, repo, rev, sha256, ...}:
  fetchurl {
    url = "https://${domain}/${owner}/${repo}/releases/download/${rev}/${lib.concatStringsSep "-" (namePrefix ++ [ pname ])}-${rev}.tbz";
    inherit sha256;
  };
in

mkCoqDerivation {
  inherit namePrefix pname fetcher;
  owner = "jasmin-lang";
  repo = "coqword";
  useDune = true;

  releaseRev = v: "v${v}";

  release."3.0".sha256 = "sha256-xEgx5HHDOimOJbNMtIVf/KG3XBemOS9XwoCoW6btyJ4=";
  release."2.2".sha256 = "sha256-8BB6SToCrMZTtU78t2K+aExuxk9O1lCqVQaa8wabSm8=";
  release."2.1".sha256 = "sha256-895gZzwwX8hN9UUQRhcgRlphHANka9R0PRotfmSEelA=";
  release."2.0".sha256 = "sha256-ySg3AviGGY5jXqqn1cP6lTw3aS5DhawXEwNUgj7pIjA=";

  inherit version;
  defaultVersion = with lib.versions; lib.switch [ coq.version mathcomp.version ] [
    { cases = [ (range "8.16" "8.19") (isGe "2.0")          ]; out = "3.0"; }
    { cases = [ (range "8.12" "8.19") (range "1.12" "1.19") ]; out = "2.2"; }
  ] null;

  propagatedBuildInputs = [ mathcomp.algebra mathcomp.ssreflect mathcomp.fingroup ];

  meta = with lib; {
    description = "Yet Another Coq Library on Machine Words";
    maintainers = [ maintainers.vbgl ];
    license = licenses.mit;
  };
}
