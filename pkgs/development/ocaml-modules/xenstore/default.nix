{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  lwt,
  ounit2,
}:

buildDunePackage rec {
  pname = "xenstore";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-xenstore";
    tag = "v${version}";
    hash = "sha256-a90pCVpgW3xR1fXrXUaEMek4/0DBXq4ysmQKg3NxwE8=";
  };

  propagatedBuildInputs = [ lwt ];

  doCheck = true;
  checkInputs = [ ounit2 ];

  meta = {
    description = "Xenstore protocol in pure OCaml";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.sternenseemann ];
    teams = [ lib.teams.xen ];
    homepage = "https://github.com/mirage/ocaml-xenstore";
  };
}
