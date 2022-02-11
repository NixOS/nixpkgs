{ lib
, buildDunePackage
, tezos-stdlib
, tezos-event-logging
, re
, ptime
, mtime
, ipaddr
, ezjsonm
, fmt
}:

buildDunePackage {
  pname = "tezos-stdlib-unix";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_stdlib_unix";

  propagatedBuildInputs = [
    tezos-event-logging
    re
    ptime
    mtime
    ipaddr
    ezjsonm
    fmt
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: yet-another local-extension of the OCaml standard library (unix-specific fragment)";
  };
}
