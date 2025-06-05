{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  menhir,
  bos,
  cmdliner,
  dolmen_type,
  fpath,
  hc,
  menhirLib,
  ocaml_intrinsics,
  ocaml_intrinsics_kernel,
  patricia-tree,
  prelude,
  scfg,
  sedlex,
  yojson,
  zarith,
  ounit2,
}:

buildDunePackage rec {
  pname = "smtml";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "formalsec";
    repo = "smtml";
    tag = "v${version}";
    hash = "sha256-QxVORnu28mcs54ZEPMxI5Bch/+/gkIfn0bTqrnSKUOw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    menhir
  ];

  buildInputs = [
    bos
    cmdliner
    dolmen_type
    fpath
    hc
    menhir
    menhirLib
    ocaml_intrinsics
    ocaml_intrinsics_kernel
    patricia-tree
    prelude
    scfg
    sedlex
    yojson
    zarith
  ];

  checkInputs = [
    ounit2
  ];

  doCheck = true;

  meta = {
    description = "SMT solver frontend for OCaml";
    homepage = "https://formalsec.github.io/smtml/smtml/";
    downloadPage = "https://github.com/formalsec/smtml";
    changelog = "https://github.com/formalsec/smtml/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}
