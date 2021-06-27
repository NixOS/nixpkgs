{ lib, buildDunePackage, fetchurl
, ke, duff, decompress, cstruct, optint, bigstringaf, stdlib-shims
, bigarray-compat, checkseum, logs, psq, fmt
, result, rresult, fpath, base64, bos, digestif, mmap, alcotest
, crowbar, alcotest-lwt, lwt, findlib, mirage-flow, cmdliner, hxd
}:

buildDunePackage rec {
  pname = "carton";
  version = "0.4.1";

  useDune2 = true;
  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-git/releases/download/${pname}-v${version}/${pname}-${pname}-v${version}.tbz";
    sha256 = "d16aad5560d9ab1e3b4d93d2e8fdea638c216ff47338fb630a8aefd22b452665";
  };

  # remove changelogs for mimic and the git* packages
  postPatch = ''
    rm CHANGES.md
  '';

  buildInputs = [
    cmdliner
    digestif
    mmap
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
    stdlib-shims
    bigarray-compat
    checkseum
    logs
    psq
    fmt
  ];

  doCheck = true;
  checkInputs = [
    base64
    alcotest
    alcotest-lwt
    crowbar
    lwt
    findlib
    mirage-flow
  ];

  meta = with lib; {
    description = "Implementation of PACKv2 file in OCaml";
    license = licenses.mit;
    homepage = "https://github.com/mirage/ocaml-git";
    maintainers = [ maintainers.sternenseemann ];
  };
}
