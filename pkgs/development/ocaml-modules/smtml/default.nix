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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "formalsec";
    repo = "smtml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IFjaZcwBiM/xA39W+FuJ87OSEvAhvhEsZ1cF2KrxrhY=";
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
    maintainers = with lib.maintainers; [
      ethancedwards8
      redianthus
    ];
  };
})
