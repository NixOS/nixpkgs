{
  lib,
  fetchFromGitHub,
  ocaml,
  buildDunePackage,
  cppo,
  ounit2,
}:

buildDunePackage (finalAttrs: {
  pname = "arg-complete";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "sim642";
    repo = "ocaml-arg-complete";
    tag = finalAttrs.version;
    hash = "sha256-tDQQeo+IfCIkbkeH6XJCHup76PD9R4x1+jGOQqPDZh8=";
  };

  nativeBuildInputs = [ cppo ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit2 ];

  meta = {
    description = "Bash completion support for OCaml Stdlib.Arg";
    homepage = "https://sim642.github.io/ocaml-arg-complete/";
    changelog = "https://raw.githubusercontent.com/sim642/ocaml-arg-complete/refs/tags/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vbgl ];
  };
})
