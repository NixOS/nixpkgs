{ buildDunePackage, awa
, cstruct, mtime, lwt, cstruct-unix, mirage-crypto-rng
}:

buildDunePackage {
  pname = "awa-lwt";

  inherit (awa) version src;

  duneVersion = "3";

  propagatedBuildInputs = [
    awa cstruct mtime lwt mirage-crypto-rng
  ];

  doCheck = true;
  nativeCheckInputs = [ awa ];
  checkInputs = [ cstruct-unix ];

  meta = awa.meta // { mainProgram = "awa_lwt_server"; };
}
