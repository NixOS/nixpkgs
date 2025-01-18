{
  lib,
  mlx,
  buildDunePackage,
  ppxlib,
  merlin-lib,
  cppo,
  csexp,
  menhir,
  odoc,
}:
buildDunePackage {
  pname = "ocamlmerlin-mlx";

  inherit (mlx) version src;

  minimalOCamlVersion = "4.14";

  buildInputs = [
    ppxlib
    merlin-lib
    csexp
    menhir
    odoc
  ];

  nativeBuildInputs = [
    cppo
  ];

  meta = with lib; {
    description = "Merlin support for MLX OCaml dialect";
    homepage = "https://github.com/ocaml-mlx/mlx";
    license = licenses.mit;
    maintainers = [ maintainers.Denommus ];
    mainProgram = "ocamlmerlin-mlx";
  };
}
