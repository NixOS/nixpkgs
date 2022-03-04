{ buildDunePackage, metrics, metrics-influx
, cstruct, ipaddr, logs, lwt, mirage-clock, mirage-stack
}:

buildDunePackage {
  pname = "metrics-mirage";
  inherit (metrics) version src;

  propagatedBuildInputs = [ cstruct ipaddr logs lwt metrics metrics-influx mirage-clock mirage-stack ];

  meta = metrics.meta // {
    description = "Mirage backend for the Metrics library";
  };
}
