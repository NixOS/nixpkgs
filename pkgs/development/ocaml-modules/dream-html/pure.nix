{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  uri,
}:

buildDunePackage rec {
  pname = "pure-html";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "yawaramin";
    repo = "dream-html";
    tag = "v${version}";
    hash = "sha256-LywQG5AaQrrq8lW+aN1doB1MKPSMciZISOeo583Kr9k=";
  };

  propagatedBuildInputs = [ uri ];

  meta = {
    description = "Write HTML directly in your OCaml source files with editor support.";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.naora ];
  };
}
