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
  version = "0.28.1.1";
  minimalOcamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocaml-mlx";
    repo = "ocamlformat-mlx";
    tag = version;
    hash = "sha256-WmY8H8Ved7/f8gTnOxoogokC0Up4BOBdM0Q6mQmZGvc=";
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
