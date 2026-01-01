{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ppxlib,
  menhir,
}:

buildDunePackage rec {
  pname = "mlx";
  version = "0.10";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitHub {
    owner = "ocaml-mlx";
    repo = "mlx";
    rev = version;
    hash = "sha256-g2v6U4lubYIVKUkU0j+OwtPxK9tKvleuX+vA4ljJ1bA=";
  };

  buildInputs = [
    ppxlib
    menhir
  ];

<<<<<<< HEAD
  meta = {
    description = "OCaml syntax dialect which adds JSX syntax expressions";
    homepage = "https://github.com/ocaml-mlx/mlx";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ Denommus ];
=======
  meta = with lib; {
    description = "OCaml syntax dialect which adds JSX syntax expressions";
    homepage = "https://github.com/ocaml-mlx/mlx";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ Denommus ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
