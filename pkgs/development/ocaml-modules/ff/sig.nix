{ lib, fetchFromGitLab, buildDunePackage, zarith }:

buildDunePackage rec {
  pname = "ff-sig";
  version = "0.6.2";
  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "cryptography/ocaml-ff";
    rev = version;
    hash = "sha256-IoUH4awMOa1pm/t8E5io87R0TZsAxJjGWaXhXjn/w+Y=";
  };

  duneVersion = "3";

  propagatedBuildInputs = [
    zarith
  ];

  doCheck = true;

  meta = {
    inherit (src.meta) homepage;
    description = "Minimal finite field signatures";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
