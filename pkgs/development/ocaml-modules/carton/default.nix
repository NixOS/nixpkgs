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
  cmdliner_1,
  hxd,
  getconf,
  replaceVars,
}:

buildDunePackage rec {
  pname = "carton";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/${pname}-v${version}/git-${pname}-v${version}.tbz";
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
    cmdliner_1
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

  # Alcotest depends on cmdliner ≥ 2.0
  doCheck = false;
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
}
