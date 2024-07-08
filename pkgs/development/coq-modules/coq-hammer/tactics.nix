{ lib, mkCoqDerivation, coq, version ? null }:

let
  owner = "lukaszcz";
  repo = "coqhammer";
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = "8.19"; out = "1.3.2+8.19"; }
    { case = "8.18"; out = "1.3.2+8.18"; }
    { case = "8.17"; out = "1.3.2+8.17"; }
    { case = "8.16"; out = "1.3.2+8.16"; }
  ] null;

  release = {
    "1.3.2+8.19".sha256 = "sha256-Zd7piAWlKPAZKEz7HVWxhnzOLbA/eR9C/E0T298MJVY=";
    "1.3.2+8.18".sha256 = "sha256-D+tQ+1YrSbbqc54U5UlxW1Hhly49TB2pu1LEPL2Eo64=";
    "1.3.2+8.17".sha256 = "sha256-2fw66z3yFKs5g+zNCeYXiEyxPzjUr+lGDciiQiuuMAs=";
    "1.3.2+8.16".sha256 = "sha256-+j2Mg9n4heXbhjRaqiTQfgBxRqfw6TPYbIuCdhu8OeE=";
  };

  releaseRev = v: "refs/tags/v${v}";

in

mkCoqDerivation {
  inherit version;
  pname = "coq-hammer-tactics";

  inherit owner repo defaultVersion release releaseRev;
  passthru = {
    inherit owner repo defaultVersion release releaseRev;
  };

  mlPlugin = true;

  buildFlags = [ "tactics" ];
  installTargets = [ "install-tactics" ];

  meta = {
    description = "Reconstruction tactics for the hammer for Coq";
    homepage = "https://github.com/lukaszcz/coqhammer";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
