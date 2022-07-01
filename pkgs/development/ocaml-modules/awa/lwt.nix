{ buildDunePackage, awa
, cstruct, mtime, lwt, cstruct-unix, mirage-crypto-rng
}:

buildDunePackage {
  pname = "awa-lwt";

  inherit (awa) version src useDune2;

  propagatedBuildInputs = [
    awa cstruct mtime lwt cstruct-unix mirage-crypto-rng
  ];

  meta = awa.meta // { mainProgram = "awa_lwt_server"; };
}
