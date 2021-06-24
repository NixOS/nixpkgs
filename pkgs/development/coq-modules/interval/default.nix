{ lib, mkCoqDerivation, which, autoconf
, coq, coquelicot, flocq, mathcomp
, bignums ? null, version ? null }:

with lib; mkCoqDerivation {
  pname = "interval";
  owner = "coqinterval";
  domain = "gitlab.inria.fr";
  inherit version;
  defaultVersion = with versions; switch coq.coq-version [
    { case = isGe "8.8" ;        out = "4.1.0"; }
    { case = range "8.8" "8.12"; out = "4.0.0"; }
    { case = range "8.7" "8.11"; out = "3.4.2"; }
    { case = range "8.5" "8.6";  out = "3.3.0"; }
  ] null;
  release."4.1.0".sha256 = "1jv27n5c4f3a9d8sizraa920iqi35x8cik8lm7pjp1dkiifz47nb";
  release."4.0.0".sha256 = "1hhih6zmid610l6c8z3x4yzdzw9jniyjiknd1vpkyb2rxvqm3gzp";
  release."3.4.2".sha256 = "07ngix32qarl3pjnm9d0vqc9fdrgm08gy7zp306hwxjyq7h1v7z0";
  release."3.3.0".sha256 = "0lz2hgggzn4cvklvm8rpaxvwaryf37i8mzqajqgdxdbd8f12acsz";
  releaseRev = v: "interval-${v}";

  nativeBuildInputs = [ which autoconf ];
  propagatedBuildInputs = [ bignums coquelicot flocq ];
  useMelquiondRemake.logpath = "Interval";

  meta = with lib; {
    description = "Tactics for simplifying the proofs of inequalities on expressions of real numbers for the Coq proof assistant";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ vbgl ];
  };
}
