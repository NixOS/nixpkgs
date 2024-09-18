{ buildDunePackage, carton, carton-lwt
, bigstringaf, lwt, fpath, result
, fmt, decompress, astring
}:

buildDunePackage {
  pname = "carton-git";

  inherit (carton) version src postPatch;
  duneVersion = "3";

  propagatedBuildInputs = [
    carton
    carton-lwt
    bigstringaf
    lwt
    fpath
    result
    fmt
    decompress
    astring
  ];

  inherit (carton) meta;
}
