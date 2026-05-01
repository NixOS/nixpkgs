{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  uri,
}:

buildDunePackage rec {
  pname = "pure-html";
  version = "3.11.1";

  src = fetchFromGitHub {
    owner = "yawaramin";
    repo = "dream-html";
    tag = "v${version}";
    hash = "sha256-L/q3nxUONPdZtzmfCfP8nnNCwQNSpeYI0hqowioGYNg=";
  };

  propagatedBuildInputs = [ uri ];

  meta = {
    description = "Write HTML directly in your OCaml source files with editor support";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.naora ];
  };
}
