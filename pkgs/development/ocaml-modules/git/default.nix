{
  stdenv,
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
  mirage-crypto-rng,
  git-binary,
  angstrom,
  astring,
  decompress,
  digestif,
  encore,
  fmt,
  checkseum,
  ke,
  logs,
  lwt,
  ocamlgraph,
  uri,
  rresult,
  base64,
  hxd,
  bigstringaf,
  optint,
  mirage-flow,
  domain-name,
  emile,
  mimic,
  carton,
  carton-lwt,
  carton-git,
  ipaddr,
  psq,
  crowbar,
  alcotest-lwt,
  cmdliner,
}:

buildDunePackage (finalAttrs: {
  pname = "git";
  version = "3.19.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/${finalAttrs.version}/git-${finalAttrs.version}.tbz";
    hash = "sha256-InOF9DGjnNoiCUYVrkydg0vJHVHMLYLhc52zB/mYfG0=";
  };

  buildInputs = [
    base64
  ];
  propagatedBuildInputs = [
    angstrom
    astring
    checkseum
    decompress
    digestif
    encore
    fmt
    ke
    logs
    lwt
    ocamlgraph
    uri
    rresult
    bigstringaf
    optint
    mirage-flow
    domain-name
    emile
    mimic
    carton
    carton-lwt
    carton-git
    ipaddr
    psq
    hxd
  ];
  nativeCheckInputs = [
    git-binary
  ];
  checkInputs = [
    alcotest
    alcotest-lwt
    mirage-crypto-rng
    crowbar
    cmdliner
  ];
  doCheck = !stdenv.hostPlatform.isAarch64;

  meta = {
    description = "Git format and protocol in pure OCaml";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      sternenseemann
      vbgl
    ];
    homepage = "https://github.com/mirage/ocaml-git";
  };
})
