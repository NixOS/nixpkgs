{ buildDunePackage, logs, lwt, metrics }:

buildDunePackage {
  pname = "metrics-lwt";

  inherit (metrics) version src;

  propagatedBuildInputs = [ logs lwt metrics ];

  meta = metrics.meta // {
    description = "Lwt backend for the Metrics library";
  };

}
