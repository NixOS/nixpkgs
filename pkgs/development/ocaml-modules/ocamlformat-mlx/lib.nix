{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  menhir,
  alcotest,
  base,
  dune-build-info,
  either,
  fix,
  fpath,
  menhirLib,
  menhirSdk,
  ocaml-version,
  ocamlformat-rpc-lib,
  ocp-indent,
  stdio,
  uuseg,
  csexp,
  astring,
  result,
  camlp-streams,
  odoc,
}:
buildDunePackage (finalAttrs: {
  pname = "ocamlformat-mlx-lib";
  version = "0.28.1.2";

  src = fetchFromGitHub {
    owner = "ocaml-mlx";
    repo = "ocamlformat-mlx";
    tag = finalAttrs.version;
    hash = "sha256-IxX8FD7v9evHFTCnTJBtnUMUUTWI34zIifpciuJCuhs=";
  };

  propagatedBuildInputs = [
    alcotest
    base
    dune-build-info
    either
    fix
    fpath
    menhirLib
    menhirSdk
    ocaml-version
    ocamlformat-rpc-lib
    ocp-indent
    stdio
    uuseg
    csexp
    astring
    result
    camlp-streams
    odoc
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
