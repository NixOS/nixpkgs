{
  lib,
  buildDunePackage,
  opam,
  jsonm,
  ocamlgraph,
  re,
  sha,
  swhid_core,
  uutf,
  patch,
}:

buildDunePackage {
  pname = "opam-core";

  inherit (opam) src version;

  propagatedBuildInputs = [
    jsonm
    ocamlgraph
    uutf
    re
    sha
    swhid_core
    patch
  ];

  # get rid of check for curl at configure time
  # opam-core does not call curl at run time
  configureFlags = [ "--disable-checks" ];

  meta = opam.meta // {
    description = "Small standard library extensions, and generic system interaction modules used by opam";
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
