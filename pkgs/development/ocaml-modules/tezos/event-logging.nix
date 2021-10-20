{ lib
, buildDunePackage
, tezos-stdlib
, tezos-error-monad
, data-encoding
, lwt_log
, lwt
}:

buildDunePackage {
  pname = "tezos-event-logging";
  inherit (tezos-stdlib) version useDune2;
  src = "${tezos-stdlib.base_src}/src/lib_event_logging";

  propagatedBuildInputs = [
    tezos-stdlib
    tezos-error-monad
    data-encoding
    lwt_log
    lwt
  ];

  doCheck = true;

  meta = tezos-stdlib.meta // {
    description = "Tezos: event logging library";
  };
}
