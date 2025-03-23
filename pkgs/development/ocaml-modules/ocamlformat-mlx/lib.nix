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
buildDunePackage rec {
  pname = "ocamlformat-mlx-lib";
  version = "0.26.2.0";
  minimalOcamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocaml-mlx";
    repo = "ocamlformat-mlx";
    rev = version;
    hash = "sha256-I9ZP8Ory/CRFbHUCe5NkZKKYMwtL1gl8xw965k5R718=";
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
}
