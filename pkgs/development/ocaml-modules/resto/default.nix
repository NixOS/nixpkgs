{ lib, fetchFromGitLab, buildDunePackage, uri }:

buildDunePackage rec {
  pname = "resto";
  version = "0.7";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "resto";
    rev = "v${version}";
    sha256 = "sha256-aX7w/rsoOmbni8BOXa0WnoQ47Y5zl91vWvMobuNFT3Y=";
  };

  propagatedBuildInputs = [
    uri
  ];

  # resto has infinite recursion in their tests
  doCheck = false;

  meta = {
    description = "A minimal OCaml library for type-safe HTTP/JSON RPCs";
    homepage = "https://gitlab.com/nomadic-labs/resto";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
