{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  findlib,
  dune-configurator,
  cppo,
  graphics,
  lablgtk,
  stdio,
}:

buildDunePackage (finalAttrs: {
  pname = "camlimages";
  version = "5.0.5";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitLab {
    owner = "camlspotter";
    repo = "camlimages";
    rev = finalAttrs.version;
    hash = "sha256-/Dkj8IBVPjGCJCXrLOuJtuaa+nD/a9e8/N+TN9ukw4k=";
  };

  # stdio v0.17 compatibility
  patches = [ ./camlimages.patch ];

  nativeBuildInputs = [ cppo ];
  buildInputs = [
    dune-configurator
    findlib
    graphics
    lablgtk
    stdio
  ];

  meta = {
    branch = "5.0";
    inherit (finalAttrs.src.meta) homepage;
    description = "OCaml image processing library";
    license = lib.licenses.lgpl2;
    maintainers = [
      lib.maintainers.vbgl
      lib.maintainers.mt-caret
    ];
  };
})
