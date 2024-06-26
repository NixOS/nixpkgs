{
  buildDunePackage,
  carton,
  carton-lwt,
  bigstringaf,
  lwt,
  fpath,
  result,
  fmt,
  decompress,
  astring,
  alcotest,
  alcotest-lwt,
  cstruct,
  logs,
  mirage-flow,
  rresult,
  ke,
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
