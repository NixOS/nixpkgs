{ buildDunePackage, metrics
, fmt, logs
}:

buildDunePackage {
  pname = "metrics-rusage";
  inherit (metrics) src version;

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [ fmt logs metrics ];

  doCheck = true;

  meta = metrics.meta // {
    description = "Resource usage (getrusage) sources for the Metrics library";
  };
}
