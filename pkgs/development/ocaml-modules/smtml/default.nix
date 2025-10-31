{
  lib,
  stdenv,
  buildDunePackage,
  ocaml,
  fetchFromGitHub,
  menhir,
  bos,
  cmdliner,
  dolmen_model,
  dolmen_type,
  fpath,
  hc,
  menhirLib,
  mtime,
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

buildDunePackage (finalAttrs: {
  pname = "smtml";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "formalsec";
    repo = "smtml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8AAS7C/X9YnkgZORRauKqPgXPyFXOhPvd7/VS693e8Q=";
  };

  nativeBuildInputs = [
    menhir
  ];

  propagatedBuildInputs = [
    bos
    cmdliner
    dolmen_model
    dolmen_type
    fpath
    hc
    menhirLib
    mtime
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

  doCheck =
    !(
      lib.versions.majorMinor ocaml.version == "5.0"
      || lib.versions.majorMinor ocaml.version == "5.4"
      || stdenv.hostPlatform.isDarwin
    );

  meta = {
    description = "SMT solver frontend for OCaml";
    homepage = "https://formalsec.github.io/smtml/smtml/";
    downloadPage = "https://github.com/formalsec/smtml";
    changelog = "https://github.com/formalsec/smtml/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
})
