{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ppxlib,
  menhir,
}:

buildDunePackage (finalAttrs: {
  pname = "mlx";
  version = if lib.versionAtLeast ppxlib.version "0.38" then "0.12" else "0.11";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitHub {
    owner = "ocaml-mlx";
    repo = "mlx";
    tag = finalAttrs.version;
    hash =
      {
        "0.12" = "sha256-7CiSa7YYCnoK1wSVQYyX8WwuWCCtXFKGJabpGameMbU=";
        "0.11" = "sha256-6cz/nbFGSxE1minncJujZi14TmM8ctDygJP4rmewYgo=";
      }
      ."${finalAttrs.version}";
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
