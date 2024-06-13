{ lib, buildDunePackage
, opam, unzip
, opam-state, opam-solver, base64, opam-repository, re, cmdliner
}:

buildDunePackage rec {
  pname = "opam-client";
  inherit (opam) src version;

  duneVersion = "3";

  nativeBuildInputs = [ unzip ];

  propagatedBuildInputs = [
    opam-state
    opam-solver
    base64
    opam-repository
    re
    cmdliner
  ];

  # get rid of check for curl at configure time
  configureFlags = [ "--disable-checks" ];

  meta = opam.meta // {
    description = "Client library for opam";
    maintainers = with lib.maintainers; [ niols ];
  };
}
