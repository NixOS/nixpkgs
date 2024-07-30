{ lib, buildDunePackage, opam, opam-repository, spdx_licenses }:

buildDunePackage rec {
  pname = "opam-state";

  inherit (opam) src version;

  # get rid of check for curl at configure time
  # opam-state does not call curl at run time
  configureFlags = [ "--disable-checks" ];

  propagatedBuildInputs = [ opam-repository spdx_licenses ];

  meta = opam.meta // {
    description = "OPAM development library handling the ~/.opam hierarchy, repository and switch states";
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
