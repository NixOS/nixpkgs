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

buildDunePackage rec {
  pname = "camlimages";
  version = "5.0.5";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitLab {
    owner = "camlspotter";
    repo = pname;
    rev = version;
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

  meta = with lib; {
    branch = "5.0";
    inherit (src.meta) homepage;
    description = "OCaml image processing library";
    license = licenses.lgpl2;
    maintainers = [
      maintainers.vbgl
      maintainers.mt-caret
    ];
  };
}
