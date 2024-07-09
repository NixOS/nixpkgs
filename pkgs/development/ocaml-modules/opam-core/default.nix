{ lib, buildDunePackage, unzip
, opam, ocamlgraph, re, cppo }:

buildDunePackage rec {
  pname = "opam-core";

  inherit (opam) src version;

  useDune2 = true;

  nativeBuildInputs = [ unzip cppo ];
  propagatedBuildInputs = [ ocamlgraph re ];

  # get rid of check for curl at configure time
  # opam-core does not call curl at run time
  configureFlags = [ "--disable-checks" ];

  meta = opam.meta // {
    description = "Small standard library extensions, and generic system interaction modules used by opam";
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
