{ buildDunePackage, metrics
, duration, fmt, lwt
}:

buildDunePackage rec {
  pname = "metrics-influx";
  inherit (metrics) version src;

  propagatedBuildInputs = [ duration fmt lwt metrics ];

  meta = metrics.meta // {
    description = "Influx reporter for the Metrics library";
  };
}
