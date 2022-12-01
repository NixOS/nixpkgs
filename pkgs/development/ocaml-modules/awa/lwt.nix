{ buildDunePackage, awa
, cstruct, mtime, lwt, cstruct-unix, mirage-crypto-rng
}:

buildDunePackage {
  pname = "awa-lwt";

  inherit (awa) version src;

  propagatedBuildInputs = [
    awa cstruct mtime lwt mirage-crypto-rng
  ];

  doCheck = true;
  checkInputs = [ cstruct-unix ];

  meta = awa.meta // { mainProgram = "awa_lwt_server"; };
}
