{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  pruviloj,
  lib,
}:
build-idris-package {
  pname = "js";
  version = "2018-11-27";

  idrisDeps = [
    contrib
    pruviloj
  ];

  src = fetchFromGitHub {
    owner = "rbarreiro";
    repo = "idrisjs";
    rev = "1ce91ecec69a7174c20bff927aeac3928a01ed3f";
    hash = "sha256-ihkjGiOZGQD+pWxKHnL0e6ef2EKsPWshCFj6sxiDkI8=";
  };

  meta = {
    description = "Js libraries for idris";
    homepage = "https://github.com/rbarreiro/idrisjs";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
