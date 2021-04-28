{ buildDunePackage, carton, carton-lwt
, bigarray-compat, bigstringaf, lwt, fpath, result
, mmap, fmt, decompress, astring
, alcotest, alcotest-lwt, cstruct, logs
, mirage-flow, rresult, ke
}:

buildDunePackage {
  pname = "carton-git";

  inherit (carton) version src useDune2 minimumOCamlVersion postPatch;

  propagatedBuildInputs = [
    carton
    carton-lwt
    bigarray-compat
    bigstringaf
    lwt
    fpath
    result
    mmap
    fmt
    decompress
    astring
  ];

  inherit (carton) meta;
}
