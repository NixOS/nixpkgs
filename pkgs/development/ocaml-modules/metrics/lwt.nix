{ buildDunePackage, logs, ocaml_lwt, metrics }:

buildDunePackage {
  pname = "metrics-lwt";

  inherit (metrics) version useDune2 src;

  propagatedBuildInputs = [ logs ocaml_lwt metrics ];

  meta = metrics.meta // {
    description = "Lwt backend for the Metrics library";
  };

}
