{ buildDunePackage, metrics
, duration, fmt, lwt
}:

buildDunePackage rec {
  pname = "metrics-influx";
  inherit (metrics) version src;

  duneVersion = "3";

  propagatedBuildInputs = [ duration fmt lwt metrics ];

  meta = metrics.meta // {
    description = "Influx reporter for the Metrics library";
  };
}
