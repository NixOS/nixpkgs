{
  lib,
  buildDunePackage,
  fetchurl,
  ke,
  duff,
  decompress,
  cstruct,
  optint,
  bigstringaf,
  checkseum,
  logs,
  psq,
  fmt,
  result,
  rresult,
  fpath,
  base64,
  bos,
  digestif,
  alcotest,
  crowbar,
  alcotest-lwt,
  lwt,
  findlib,
  mirage-flow,
  cmdliner,
  hxd,
  getconf,
  replaceVars,
}:

buildDunePackage (finalAttrs: {
  pname = "carton";
  version = "0.7.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/carton-v${finalAttrs.version}/git-carton-v${finalAttrs.version}.tbz";
    hash = "sha256-vWkBJdP4ZpRCEwzrFMzsdHay4VyiXix/+1qzk+7yDvk=";
  };

  patches = [
    (replaceVars ./carton-find-getconf.patch {
      getconf = "${getconf}";
    })
  ];

  # remove changelogs for mimic and the git* packages
  postPatch = ''
    rm CHANGES.md
  '';

  buildInputs = [
    cmdliner
    digestif
    result
    rresult
    fpath
    bos
    hxd
  ];
  propagatedBuildInputs = [
    ke
    duff
    decompress
    cstruct
    optint
    bigstringaf
    checkseum
    logs
    psq
    fmt
  ];

  doCheck = true;
  nativeBuildInputs = [
    findlib
  ];
  checkInputs = [
    base64
    alcotest
    alcotest-lwt
    crowbar
    lwt
    mirage-flow
  ];

  meta = {
    description = "Implementation of PACKv2 file in OCaml";
    license = lib.licenses.mit;
    homepage = "https://github.com/mirage/ocaml-git";
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
