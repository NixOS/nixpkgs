{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ppxlib,
  menhir,
}:

buildDunePackage (finalAttrs: {
  pname = "mlx";
  version = "0.11";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitHub {
    owner = "ocaml-mlx";
    repo = "mlx";
    tag = finalAttrs.version;
    hash = "sha256-6cz/nbFGSxE1minncJujZi14TmM8ctDygJP4rmewYgo=";
  };

  buildInputs = [
    ppxlib
    menhir
  ];

  meta = {
    description = "OCaml syntax dialect which adds JSX syntax expressions";
    homepage = "https://github.com/ocaml-mlx/mlx";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ Denommus ];
  };
})
