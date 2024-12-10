{
  lib,
  buildDunePackage,
  unzip,
  opam,
  opam-repository,
}:

buildDunePackage rec {
  pname = "opam-state";

  inherit (opam) src version;

  useDune2 = true;

  # get rid of check for curl at configure time
  # opam-state does not call curl at run time
  configureFlags = [ "--disable-checks" ];

  nativeBuildInputs = [ unzip ];
  propagatedBuildInputs = [ opam-repository ];

  meta = opam.meta // {
    description = "OPAM development library handling the ~/.opam hierarchy, repository and switch states";
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
