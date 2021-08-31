{ lib
, buildDunePackage
, tezos-stdlib
, tezos-event-logging
, lwt
, ptime
, mtime
, ipaddr
, re
, alcotest
, alcotest-lwt
}:

buildDunePackage {
  pname = "tezos-stdlib-unix";
  inherit (tezos-stdlib) version src useDune2 preBuild doCheck;

  propagatedBuildInputs = [
    tezos-event-logging
    lwt
    ptime
    mtime
    ipaddr
    re
  ];

  meta = tezos-stdlib.meta // {
    description = "Tezos: yet-another local-extension of the OCaml standard library (unix-specific fragment)";
  };
}
