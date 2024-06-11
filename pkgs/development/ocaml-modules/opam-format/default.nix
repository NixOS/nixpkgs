{ lib, buildDunePackage, unzip, opam-core, opam-file-format }:

buildDunePackage rec {
  pname = "opam-format";

  useDune2 = true;

  inherit (opam-core) src version;

  minimumOCamlVersion = "4.02.3";

  # get rid of check for curl at configure time
  # opam-format does not call curl at run time
  configureFlags = [ "--disable-checks" ];

  nativeBuildInputs = [ unzip ];
  propagatedBuildInputs = [ opam-core opam-file-format ];

  meta = opam-core.meta // {
    description = "Definition of opam datastructures and its file interface";
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
