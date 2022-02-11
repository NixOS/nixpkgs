{ lib, mkCoqDerivation, which, autoconf, coq, coquelicot, flocq, bignums ? null, gnuplot_qt, version ? null }:

mkCoqDerivation rec {
  pname = "interval";
  owner = "coqinterval";
  domain = "gitlab.inria.fr";
  inherit version;
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = isGe "8.8"; out = "4.4.0"; }
    { case = range "8.8" "8.12"; out = "4.0.0"; }
    { case = range "8.7" "8.11"; out = "3.4.2"; }
    { case = range "8.5" "8.6";  out = "3.3.0"; }
  ] null;
  release."4.4.0".sha256 = "sha256-0+9AatTIEsjul0RXoOw6zWGEbGDVmuy7XuyrZNBZ8Kk=";
  release."4.3.0".sha256 = "sha256-k8DLC4HYYpHeEEgXUafS8jkaECqlM+/CoYaInmUTYko=";
  release."4.2.0".sha256 = "sha256-SD5thgpirs3wmZBICjXGpoefg9AAXyExb5t8tz3iZhE=";
  release."4.1.1".sha256 = "sha256-h2NJ6sZt1C/88v7W2xyuftEDoyRt3H6kqm5g2hc1aoU=";
  release."4.0.0".sha256 = "1hhih6zmid610l6c8z3x4yzdzw9jniyjiknd1vpkyb2rxvqm3gzp";
  release."3.4.2".sha256 = "07ngix32qarl3pjnm9d0vqc9fdrgm08gy7zp306hwxjyq7h1v7z0";
  release."3.3.0".sha256 = "0lz2hgggzn4cvklvm8rpaxvwaryf37i8mzqajqgdxdbd8f12acsz";
  releaseRev = v: "interval-${v}";

  nativeBuildInputs = [ which autoconf ];
  propagatedBuildInputs = [ bignums coquelicot flocq ]
    ++ lib.optionals (lib.versions.isGe "4.2.0" defaultVersion) [ gnuplot_qt ];
  useMelquiondRemake.logpath = "Interval";
  mlPlugin = true;
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tactics for simplifying the proofs of inequalities on expressions of real numbers for the Coq proof assistant";
    license = licenses.cecill-c;
    maintainers = with maintainers; [ vbgl ];
  };
}
