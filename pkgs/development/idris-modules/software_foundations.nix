{
  build-idris-package,
  fetchFromGitHub,
  pruviloj,
  lib,
}:
build-idris-package {
  pname = "software_foundations";
  version = "2017-11-04";

  idrisDeps = [ pruviloj ];

  src = fetchFromGitHub {
    owner = "idris-hackers";
    repo = "software-foundations";
    rev = "eaa63d1a572c78e7ce68d27fd49ffdc01457e720";
    hash = "sha256-riMBWi+PwjTCG0woQTTeeTB9ZlxFBQKgGjnYdDqocuY=";
  };

  meta = {
    description = "Code for Software Foundations in Idris";
    homepage = "https://github.com/idris-hackers/software-foundations";
    maintainers = [ lib.maintainers.brainrape ];
  };
}
