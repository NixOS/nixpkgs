{
  lib,
  fetchurl,
  ocaml,
  buildDunePackage,
  cppo,
  ounit2,
}:

buildDunePackage rec {
  pname = "arg-complete";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/sim642/ocaml-arg-complete/releases/download/${version}/arg-complete-${version}.tbz";
    hash = "sha256-SZvLaeeqY3j2LUvqxGs0Vw57JnnpdvAk1jnE3pk27QU=";
  };

  nativeBuildInputs = [ cppo ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit2 ];

  meta = {
    description = "Bash completion support for OCaml Stdlib.Arg";
    homepage = "https://sim642.github.io/ocaml-arg-complete/";
    changelog = "https://raw.githubusercontent.com/sim642/ocaml-arg-complete/refs/tags/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
