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
  patricia-tree,
  prelude,
  scfg,
  sedlex,
  yojson,
  z3,
  zarith,
  mdx,
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

  nativeBuildInputs = [
    menhir
  ];

  buildInputs = [
    fpath
    menhirLib
    prelude
    sedlex
    zarith
  ];

  propagatedBuildInputs = [
    bos
    cmdliner
    dolmen_type
    hc
    ocaml_intrinsics
    patricia-tree
    scfg
    yojson
    z3
  ];

  checkInputs = [
    ounit2
  ];

  nativeCheckInputs = [
    mdx.bin
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
