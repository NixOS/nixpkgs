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
  dune-build-info,
  fpath,
  hc,
  menhirLib,
  mtime,
  # fix eval on legacy ocaml versions
  ocaml_intrinsics ? null,
<<<<<<< HEAD
=======
  patricia-tree,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "0.18.0";
=======
  version = "0.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "formalsec";
    repo = "smtml";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-s72m7N9Ovd2Vl4F+hb2MsNmnF1hFQGkf2s7TrJ9IWI8=";
=======
    hash = "sha256-z3DDdzU39tg2F3+pAFPILiKY3pQxOpehdoxwckyhZBI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    menhir
  ];

  propagatedBuildInputs = [
    bos
    cmdliner
    dolmen_model
    dolmen_type
    dune-build-info
    fpath
    hc
    menhirLib
    mtime
    ocaml_intrinsics
<<<<<<< HEAD
=======
    patricia-tree
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      ethancedwards8
      redianthus
    ];
=======
    maintainers = [ lib.maintainers.ethancedwards8 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
