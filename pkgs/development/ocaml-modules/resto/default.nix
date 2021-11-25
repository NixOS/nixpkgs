{ lib, fetchFromGitLab, buildDunePackage, uri }:

buildDunePackage rec {
  pname = "resto";
  version = "0.6.1";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "resto";
    rev = "v${version}";
    sha256 = "13h3zga7h2jhgbyda1q53szbpxcz3vvy3c51mlqk3jh9jq2wrn87";
  };

  useDune2 = true;

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
