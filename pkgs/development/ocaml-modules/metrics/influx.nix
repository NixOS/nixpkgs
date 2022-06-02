{ buildDunePackage, metrics
, astring, duration, fmt, lwt
}:

buildDunePackage rec {
  pname = "metrics-influx";
  inherit (metrics) version useDune2 src;

  propagatedBuildInputs = [ astring duration fmt lwt metrics ];

  meta = metrics.meta // {
    description = "Influx reporter for the Metrics library";
  };
}
