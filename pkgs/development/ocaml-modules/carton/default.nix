{ lib, buildDunePackage, fetchurl
, ke, duff, decompress, cstruct, optint, bigstringaf
, checkseum, logs, psq, fmt
, result, rresult, fpath, base64, bos, digestif, alcotest
, crowbar, alcotest-lwt, lwt, findlib, mirage-flow, cmdliner, hxd
, getconf, substituteAll
}:

buildDunePackage rec {
  pname = "carton";
  version = "0.7.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/${pname}-v${version}/git-${pname}-v${version}.tbz";
    hash = "sha256-vWkBJdP4ZpRCEwzrFMzsdHay4VyiXix/+1qzk+7yDvk=";
  };

  patches = [
    (substituteAll {
      src = ./carton-find-getconf.patch;
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

  meta = with lib; {
    description = "Implementation of PACKv2 file in OCaml";
    license = licenses.mit;
    homepage = "https://github.com/mirage/ocaml-git";
    maintainers = [ maintainers.sternenseemann ];
  };
}
