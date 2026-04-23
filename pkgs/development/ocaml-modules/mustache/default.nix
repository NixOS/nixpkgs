{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  ezjsonm,
  menhir,
  menhirLib,
  ounit2,
}:

buildDunePackage rec {
  pname = "mustache";
  version = "3.3.0";
  src = fetchFromGitHub {
    owner = "rgrinberg";
    repo = "ocaml-mustache";
    tag = "v${version}";
    hash = "sha256-7rdp7nrjc25/Nuj/cf78qxS3Qy4ufaNcKjSnYh4Ri8U=";
  };

  nativeBuildInputs = [ menhir ];
  propagatedBuildInputs = [ menhirLib ];

  doCheck = false; # Disabled because of "Error: Program mustache-ocaml not found in the tree or in PATH"
  checkInputs = [
    ezjsonm
    ounit2
  ];

  meta = {
    description = "Mustache logic-less templates in OCaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
