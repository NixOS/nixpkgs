{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  cmdliner,
  odoc,
  ocamlformat-mlx-lib,
  re,
}:
buildDunePackage rec {
  pname = "ocamlformat-mlx";
  minimalOcamlVersion = "4.08";

  inherit (ocamlformat-mlx-lib) version src meta;

  buildInputs = [
    cmdliner
    re
    odoc
    ocamlformat-mlx-lib
  ];
}
