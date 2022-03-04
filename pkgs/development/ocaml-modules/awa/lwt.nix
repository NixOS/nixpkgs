{ buildDunePackage, awa
, cstruct, mtime, lwt, cstruct-unix, mirage-crypto-rng
}:

buildDunePackage {
  pname = "awa-lwt";

  inherit (awa) version src;

  propagatedBuildInputs = [
    awa cstruct mtime lwt cstruct-unix mirage-crypto-rng
  ];

  inherit (awa) meta;
}
