{ lib, buildDunePackage, opam-core, opam-file-format }:

buildDunePackage {
  pname = "opam-format";

  inherit (opam-core) src version;

  # get rid of check for curl at configure time
  # opam-format does not call curl at run time
  configureFlags = [ "--disable-checks" ];

  propagatedBuildInputs = [ opam-core opam-file-format ];

  meta = opam-core.meta // {
    description = "Definition of opam datastructures and its file interface";
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
