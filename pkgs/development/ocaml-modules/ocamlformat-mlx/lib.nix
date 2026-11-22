{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  menhir,
  base,
  cmdliner,
  dune-build-info,
  either,
  fpath,
  menhirLib,
  ocaml-version,
  ocp-indent,
  stdio,
  uuseg,
  astring,
  camlp-streams,
}:
buildDunePackage (finalAttrs: {
  pname = "ocamlformat-mlx-lib";
  version = "0.29.0.2";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitHub {
    owner = "ocaml-mlx";
    repo = "ocamlformat-mlx";
    tag = finalAttrs.version;
    hash = "sha256-Ny9Uwc+rvIHoTfoO8iB9vHwXBJiRuhh8i8xKl9UWZjM=";
  };

  propagatedBuildInputs = [
    base
    cmdliner
    dune-build-info
    either
    fpath
    menhirLib
    ocaml-version
    ocp-indent
    stdio
    uuseg
    astring
    camlp-streams
  ];

  nativeBuildInputs = [
    menhir
  ];

  meta = {
    homepage = "https://github.com/ocaml-mlx/ocamlformat-mlx";
    description = "OCaml .mlx Code Formatter";
    maintainers = with lib.maintainers; [
      Denommus
    ];
    license = lib.licenses.mit;
  };
})
