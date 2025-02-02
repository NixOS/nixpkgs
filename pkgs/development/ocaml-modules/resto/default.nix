{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  uri,
}:

buildDunePackage rec {
  pname = "resto";
  version = "1.2";
  duneVersion = "3";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "resto";
    rev = "v${version}";
    hash = "sha256-VdkYUy7Fi53ku6F/1FV55/VcyF/tDZKN4NTMabDd/T4=";
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
