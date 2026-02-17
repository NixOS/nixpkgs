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
  _experimental-update-script-combinators,
  nix-update-script,
}:

buildDunePackage (finalAttrs: {
  pname = "smtml";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "formalsec";
    repo = "smtml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x2zUFTZHeCATnHKuBHChCSbM9kltv4AhfBaZuVU3ATQ=";
  };

  minimalOCamlVersion = "4.14";

  nativeBuildInputs = [
    menhir
  ];

  buildInputs = [
    dune-build-info
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

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script {
      attrPath = "ocamlPackages.smtml";
    })
    (nix-update-script {
      attrPath = "owi";
      extraArgs = [
        "--version=branch=main"
      ];
    })
  ];

  meta = {
    description = "SMT solver frontend for OCaml";
    homepage = "https://formalsec.github.io/smtml/smtml/";
    downloadPage = "https://github.com/formalsec/smtml";
    changelog = "https://github.com/formalsec/smtml/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [
      ethancedwards8
      redianthus
    ];
  };
})
