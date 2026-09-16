{
  buildDunePackage,
  cmdliner,
  ocamlformat-mlx-lib,
  re,
}:
buildDunePackage {
  pname = "ocamlformat-mlx";

  inherit (ocamlformat-mlx-lib) version src meta;

  buildInputs = [
    cmdliner
    re
    ocamlformat-mlx-lib
  ];
}
