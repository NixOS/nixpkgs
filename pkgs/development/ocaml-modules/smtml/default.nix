{
  lib,
  stdenv,
  buildDunePackage,
  ocaml,
  fetchFromGitHub,
  menhir,
  bos,
  cmdliner,
  dolmen_type,
  fpath,
  hc,
  menhirLib,
  # fix eval on legacy ocaml versions
  ocaml_intrinsics ? null,
  patricia-tree,
  prelude,
  scfg,
  yojson,
  z3,
  zarith,
  mdx,
  ounit2,
}:

buildDunePackage rec {
  pname = "smtml";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "formalsec";
    repo = "smtml";
    tag = "v${version}";
    hash = "sha256-WXGYk/zJnW6QzHKCHl0lkmYb/pG90/sAOK40wYzK35U=";
  };

  nativeBuildInputs = [
    menhir
  ];

  propagatedBuildInputs = [
    bos
    cmdliner
    dolmen_type
    fpath
    hc
    menhirLib
    ocaml_intrinsics
    patricia-tree
    prelude
    scfg
    yojson
    z3
    zarith
  ];

  checkInputs = [
    mdx
    ounit2
  ];

  nativeCheckInputs = [
    mdx.bin
  ];

  doCheck = !(lib.versions.majorMinor ocaml.version == "5.0" || stdenv.hostPlatform.isDarwin);

  meta = {
    description = "SMT solver frontend for OCaml";
    homepage = "https://formalsec.github.io/smtml/smtml/";
    downloadPage = "https://github.com/formalsec/smtml";
    changelog = "https://github.com/formalsec/smtml/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}
