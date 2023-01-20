{ buildDunePackage, carton
, lwt, decompress, optint, bigstringaf
, alcotest, alcotest-lwt, cstruct, fmt, logs
, mirage-flow, result, rresult, bigarray-compat
, ke, base64, bos, checkseum, digestif, fpath, mmap
, stdlib-shims
, git-binary # pkgs.git
}:

buildDunePackage {
  pname = "carton-lwt";

  inherit (carton) version src useDune2 postPatch;

  propagatedBuildInputs = [
    carton
    lwt
    decompress
    optint
    bigstringaf
  ];

  doCheck = true;
  checkInputs = [
    git-binary
    alcotest
    alcotest-lwt
    cstruct
    fmt
    logs
    mirage-flow
    result
    rresult
    bigarray-compat
    ke
    base64
    bos
    checkseum
    digestif
    fpath
    mmap
    stdlib-shims
  ];

  inherit (carton) meta;
}
