{ lib, fetchFromGitLab, buildDunePackage, uri }:

buildDunePackage rec {
  pname = "resto";
  version = "1.0";
  duneVersion = "3";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "resto";
    rev = "v${version}";
    hash = "sha256-DIm7fmISsCgRDi4p3NsUk7Cvs/dHpIKMdAOVdYLX2mc=";
  };

  propagatedBuildInputs = [
    uri
  ];

  # resto has infinite recursion in their tests
  doCheck = false;

  meta = {
    description = "Minimal OCaml library for type-safe HTTP/JSON RPCs";
    homepage = "https://gitlab.com/nomadic-labs/resto";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
