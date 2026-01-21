{
  lib,
  buildDunePackage,
  base64,
  cmdliner,
  opam,
  opam-repository,
  opam-solver,
  opam-state,
  re,
}:

buildDunePackage {
  pname = "opam-client";

  inherit (opam) src version;

  configureFlags = [ "--disable-checks" ];

  propagatedBuildInputs = [
    base64
    cmdliner
    opam-repository
    opam-solver
    opam-state
    re
  ];

  meta = opam.meta // {
    description = "Actions on the opam root, switches, installations, and front-end";
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}
